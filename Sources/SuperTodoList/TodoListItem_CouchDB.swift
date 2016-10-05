import Foundation
import Kitura
import SwiftyJSON


/**
 This example will communicate with a CouchDB database
 */

func handleGetCouchDBItems(
    request: RouterRequest,
    response: RouterResponse,
    callNextHandler: @escaping () -> Void) throws {
    response.send(json: JSON(itemStrings))
    callNextHandler()
}


func handleAddCouchDBItem(
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
    let item = jsonBody["item"].stringValue
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
