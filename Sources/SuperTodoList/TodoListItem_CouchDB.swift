import Foundation
import Kitura
import SwiftyJSON
import MiniPromiseKit

/**
 This example will communicate with a CouchDB database
 */

let queue = DispatchQueue(label: "Something", attributes: .concurrent)
let hostname = "http://127.0.0.1:5984"
let database = "todolist"
let design = "tododesign"

let urlGet = URL(string: "http://127.0.0.1:5984/todolist/_design/tododesign/_view/all_todos")
let urlAdd = URL(string: "http://127.0.0.1:5984/todolist/")

func getAllItems() -> Promise<[Item]> {
    return firstly {
        URLSession().dataTaskPromise(with: urlGet!)
        }.then(on: queue ) { data -> [Item] in
            let json = try JSONSerialization.jsonObject(with: data,
                                                        options: [])
            let j = json as? [String: Any]
            let rows = j!["rows"] as? [[String: Any]]
            
            return rows!.map { row in
                let values = row["value"] as! [String]
                
                return Item(id: UUID(), title: values[1])
            }
    }
}

func handleGetCouchDBItems(
    request: RouterRequest,
    response: RouterResponse,
    callNextHandler: @escaping () -> Void) throws {
 
    _ = firstly {
        getAllItems()
    }.then(on: queue) { items in
        print(items)
        response.send(json: JSON(items.dictionary))
    }.catch(on: queue) { error in
        print(error)
    }.always(on: queue) {
            callNextHandler()
    }
    
    
}


func handleAddCouchDBItem(
    request: RouterRequest,
    response: RouterResponse,
    callNextHandler: @escaping () -> Void ) {
 
    guard case let .json(jsonBody)? = request.body
        else {
            response.status(.badRequest)
            callNextHandler()
            return
    }
    let item = jsonBody["title"].stringValue
    
    itemStringsLock.wait()
    itemStrings.append(item)
    itemStringsLock.signal()
    
    
    response.send("Added '\(item)'\n")
    callNextHandler()
}

func addRoutesForCouchDBItems(router: Router) {
    //    router.all("/*", middleware: BodyParser())
    router.get ("/v1/item_couch", handler: handleGetCouchDBItems)
    router.post("/v1/item_couch", handler: handleAddCouchDBItem)
}
