import Foundation
import Kitura
import SwiftyJSON

var itemDictionaries: [[String: Any]] = []
let itemDictionariesLock = DispatchSemaphore(value: 1)


/**
 Gets all the items that were stored as a Dictionary
 
 curl localhost:8090/v1/item_dictionary
*/
func handleGetItemDictionaries(
        request: RouterRequest,
        response: RouterResponse,
        callNextHandler: @escaping () -> Void) throws {
    response.send(json: JSON(itemDictionaries))
    callNextHandler()
}

/**
 Adds an item to an array of Dictionary

curl -H "Content-Type: application/json" -X POST -d '{"title":"Reticulate Splines"}' localhost:8090/v1/item_dictionary
*/
func handleAddItemDictionary(
        request: RouterRequest,
        response: RouterResponse,
        callNextHandler: @escaping () -> Void ) {
    // If there is a body, and it holds JSON, store it in jsonBody
    guard case let .json(jsonBody)? = request.body,
        let title = jsonBody["title"].string
        else {
            response.status(.badRequest)
            callNextHandler()
            return
    }
    
    itemDictionariesLock.wait()
    itemDictionaries.append( [ "id": UUID().uuidString,
                               "title": title ])
    itemDictionariesLock.signal()
    response.send("Added '\(title)'\n")
    callNextHandler()
}

func addRoutesForDictItems(router: Router) {
    //    router.all("/*", middleware: BodyParser())
    router.get ("/v1/item_dictionary", handler: handleGetItemDictionaries)
    router.post("/v1/item_dictionary", handler: handleAddItemDictionary)
}
