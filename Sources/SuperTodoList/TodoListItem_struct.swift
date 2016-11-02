//
//  TodoListItem_String.swift
//  SuperTodoList
//
//  Created by David Ungar on 10/4/16.
//
//

import Foundation
import Kitura
import SwiftyJSON

var itemStructs: [Item] = []
let itemStructsLock = DispatchSemaphore(value: 1)




func handleGetItemStructs(
        request: RouterRequest,
        response: RouterResponse,
        callNextHandler: @escaping () -> Void) throws {
    response.send(json: JSON(itemStructs.dictionary))
    callNextHandler()
}
func handleAddItemStruct(
        request: RouterRequest,
        response: RouterResponse,
        callNextHandler: @escaping () -> Void ) {
    // If there is a body, and it holds JSON, store it in jsonBody
    guard case let .json(jsonBody)? = request.body
        else {
            response.status(.badRequest)
            callNextHandler()
            return
    }
    do {
        let item = try Item(json: jsonBody)
        itemStructsLock.wait()
        itemStructs.append(item)
        itemStructsLock.signal()
        response.send("Added '\(item)'\n")
        callNextHandler()
    }
    catch {
        response.status(.badRequest).send(error.localizedDescription)
        callNextHandler()
    }
}

func addRoutesForStructItems(router: Router) {
    //    router.all("/*", middleware: BodyParser())
    router.get ("/v1/item_struct", handler: handleGetItemStructs)
    router.post("/v1/item_struct", handler: handleAddItemStruct)
}
