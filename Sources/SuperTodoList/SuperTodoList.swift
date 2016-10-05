/**
 Copyright IBM Corporation 2016
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Kitura
import LoggerAPI
import SwiftyJSON
import Dispatch
import Foundation

public class SuperTodoList {
    public let router = Router()
    
    let taskDatabase = TaskDatabase()
    
    let queue = DispatchQueue(label: "com.example.todo")
    
    public init() {
        router.get("/hello") { request, response, callNextHandler in
            response.status(.OK).send("Hello, World!")
            callNextHandler()
        }
        router.all("*", middleware: BodyParser())

        addRoutesForStringItems(router: router)
        addRoutesForDictItems(router: router)
        addRoutesForStructItems(router: router)
        addRoutesForCouchDBItems(router: router)
        
    }
    
}





