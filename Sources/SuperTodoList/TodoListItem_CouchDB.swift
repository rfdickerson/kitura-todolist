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
let baseURL = "http://127.0.0.1:5984/todolist/"

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
                let uuid = UUID(uuidString: values[0]) ?? UUID()
                
                return Item(id: uuid, title: values[1])
            }
    }
}

func addItem(item: Item) -> Promise<Item> {
    return Promise { fulfill, reject in
        
        let session = URLSession(configuration: .default)
        
        let addURL = "\(baseURL)\(item.id.uuidString)"
        print("Add url is \(addURL)")
        
        guard let url = URL(string: addURL) else {
            reject(ItemError.malformedJSON)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try! JSONSerialization.data(withJSONObject: item.dictionary,
                                                       options: [] )
        
        
        let dataTask = session.dataTask(with: request) {
            data, response, error in
            
            if let error = error {
                reject(error)
            }
            
            fulfill(item)
        }
        
        
        dataTask.resume()
        
    }
}

/**
 Adds an item to an array of Dictionary
 
 curl -H "Content-Type: application/json" -X POST -d '{"title":"Reticulate Splines"}' localhost:8090/v1/item_couch
 */
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
        response.status(.badRequest)
        response.send(error.localizedDescription)
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
    
    _ = firstly { (Void) -> Promise<Item> in
        let item = try Item(json: jsonBody)
        return addItem(item: item)
    }.then(on: queue) { item in
        response.send("Added \(item.title)")
    }.catch(on: queue) { error in
        response.status(.badRequest)
        response.send(error.localizedDescription)
    }.always(on: queue) {
        callNextHandler()
    }
    
}

func addRoutesForCouchDBItems(router: Router) {
    router.get ("/v1/item_couch", handler: handleGetCouchDBItems)
    router.post("/v1/item_couch", handler: handleAddCouchDBItem)
}
