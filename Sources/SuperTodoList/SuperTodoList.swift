
import Kitura
import LoggerAPI
import SwiftyJSON
import Dispatch
import Foundation

public class SuperTodoList {
    
    public let router = Router()
    
    let queue = DispatchQueue(label: "com.example.todo")
    
    public init() {
        
        router.get("/hello") { request, response, callNextHandler in
            response.status(.OK).send("Hello, World!")
            callNextHandler()
        }
        
        router.all("*", middleware: BodyParser())

        // First Act
        addRoutesForStringItems(router: router)
        
        // Second Act
        addRoutesForDictItems(router: router)
        
        // Third Act
        addRoutesForStructItems(router: router)
        
        // Fourth Act
        addRoutesForCouchDBItems(router: router)
        
    }
    
}





