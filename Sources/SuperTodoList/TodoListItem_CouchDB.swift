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

enum JSONParsingError: Error { case malformedJSON, missingRows, missingValue }

func dataToItems(data: Data) throws -> [Item] {
    
    let json = try JSONSerialization.jsonObject(with: data,
                                                options: [])
    guard let j = json as? [String: Any] else {
        throw JSONParsingError.malformedJSON
    }
    
    guard let rows = j["rows"] as? [[String: Any]] else {
        throw JSONParsingError.missingRows
    }
    
    return rows.flatMap { row in
        guard let values = row["value"] as? [String] else {
            return nil
        }
        
        let uuid = UUID(uuidString: values[0]) ?? UUID()
        
        return Item(id: uuid, title: values[1])
    }
}

func getAllItems() -> Promise<[Item]> {
    return firstly {
        URLSession().dataTaskPromise(with: urlGet!)
    }
    .then(on: queue) { result in
        return try dataToItems(data: result)
        
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
        request.httpBody = try JSONSerialization.data(withJSONObject: item.dictionary,
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
 
    _ = firstly { (Void) -> Promise<Item> in
        guard case let .json(jsonBody)? = request.body
            else {
                throw JSONParsingError.malformedJSON
        }
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
