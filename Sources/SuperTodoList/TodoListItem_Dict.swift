//
//  SuperTodoList
//
//  Created by David Ungar on 10/4/16.
//
//

import Foundation
import Kitura

var itemDictionaries: [[String: Any]] = []
let itemDictionariesLock = DispatchSemaphore(value: 1)

import SwiftyJSON

// curl localhost:8090/v1/item_dictionary
func handleGetItemDictionaries(request: RouterRequest,
                    response: RouterResponse,
                    callNextHandler: @escaping () -> Void) throws {
    response.send(json: JSON(itemDictionaries))
    callNextHandler()
}

// curl -H "Content-Type: application/json" -X POST -d '{"title":"Reticulate Splines"}' localhost:8090/v1/item_dictionary
func handleAddItemDictionary( request: RouterRequest,
                    response: RouterResponse,
                    callNextHandler: @escaping () -> Void ) {
    // ... // Authenticate (see below)
    
    // If there is a body, and it holds JSON, store it in jsonBody
    guard case let .json(jsonBody)? = request.body
        else {
            response.status(.badRequest)
            callNextHandler()
            return
    }
    
    let title = jsonBody["title"].stringValue
    
    itemDictionariesLock.wait()
    itemDictionaries.append( [ "id": "\(UUID())",
                               "title": title ])
    
    itemDictionariesLock.signal()
    response.send("Added '\(title)'")
    callNextHandler()
}

func addRoutesForDictItems(router: Router) {
    //    router.all("/*", middleware: BodyParser())
    router.get ("/v1/item_dictionary", handler: handleGetItemDictionaries)
    router.post("/v1/item_dictionary", handler: handleAddItemDictionary)
}
