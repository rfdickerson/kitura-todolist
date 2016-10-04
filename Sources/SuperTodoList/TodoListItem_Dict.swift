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
func handleGetItemDictionaries(request: RouterRequest,
                    response: RouterResponse,
                    callNextHandler: @escaping () -> Void) throws {
    response.send(json: JSON(itemDictionaries))
    callNextHandler()
}


func handleAddItemDictionary( request: RouterRequest,
                    response: RouterResponse,
                    callNextHandler: @escaping () -> Void ) {
    // ... // Authenticate (see below)
    
    // If there is a body, and it holds JSON, store it in jsonBody
    guard case let .json(jsonBody)? = request.body,
        let item = jsonBody["item"].dictionary
        else {
            response.status(.badRequest)
            callNextHandler()
            return
    }
    itemDictionariesLock.wait()
    itemDictionaries.append(item)
    itemDictionariesLock.signal()
    response.send("Added '/(item)'")
    callNextHandler()
}

func addRoutesForDictItems(router: Router) {
    //    router.all("/*", middleware: BodyParser())
    router.get ("/v1/item_dictionary", handler: handleGetItemDictionaries)
    router.post("/v1/item_dictionary", handler: handleAddItemDictionary)
}
