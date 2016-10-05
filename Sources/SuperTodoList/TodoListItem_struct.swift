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

private struct Item {
    let id:       UUID
    let title:    String
}
private var itemStructs: [Item] = []
private let itemStructsLock = DispatchSemaphore(value: 1)


extension Item {
    init (json: JSON) throws {
        enum ItemError: String, Error { case malformedJSON }
        guard let d = json.dictionary,
            let title = d["title"]?.string  else {
            throw ItemError.malformedJSON
        }
        // If id is in the json, use it, otherwise assign a new one
        let id: UUID
        if let idJSON = d["id"] {
            guard let x = idJSON.string.flatMap(UUID.init(uuidString:))  else {
                throw ItemError.malformedJSON
            }
            id = x
        }
        else {
            id = UUID()
        }
        
        self.id = id
        self.title = title
    }
    var json: JSON {
        return JSON(["id": id.uuidString, "title": title])
    }
}

func handleGetItemStructs(request: RouterRequest,
                          response: RouterResponse,
                          callNextHandler: @escaping () -> Void) throws {
    response.send(json: JSON(itemStructs.map {$0.json}))
    callNextHandler()
}


func handleAddItemStruct( request: RouterRequest,
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
    do {
        let item = try Item(json: jsonBody)
        itemStructsLock.wait()
        itemStructs.append(item)
        itemStructsLock.signal()
        response.send("Added '\(item)'")
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
