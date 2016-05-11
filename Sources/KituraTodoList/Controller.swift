/**
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Kitura
import KituraNet

import LoggerAPI
import SwiftyJSON

import TodoListAPI

/**
 Custom middleware that allows Cross Origin HTTP requests
 This will allow wwww.todobackend.com to communicate with your server
 */
class AllRemoteOriginMiddleware: RouterMiddleware {
    func handle(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        
        response.setHeader("Access-Control-Allow-Origin", value: "*")
        
        next()
    }
}

/**
 Sets up all the routes for the Todo List application
 */
func setupRoutes(router: Router, todos: TodoListAPI) {
    
    router.all("/*", middleware: BodyParser())
    
    router.all("/*", middleware: AllRemoteOriginMiddleware())
    
    /**
     Get all the todos
     */
    router.get("/") {
        request, response, next in
        
        do {
            
            try todos.getAll() {
                todos in
                
                do {
                    let json = JSON(serialize(items: todos))
                    
                    try response.status(HTTPStatusCode.OK).send(json: json).end()
                } catch {
                    
                }
            }
        } catch {
            response.status(.badRequest)
            
        }
        
    }
    
    /**
     Get information about a todo item by ID
     */
    router.get(config.firstPathSegment + "/:id") {
        request, response, next in
        
        guard let id = request.params["id"] else {
            response.status(HTTPStatusCode.badRequest)
            Log.error("Request does not contain ID")
            return
        }
        
        do {
            try todos.get(id) {
                
                item in
                
                if let item = item {
                    
                    let result = JSON(item.serialize())
                    
                    do {
                        try response.status(HTTPStatusCode.OK).send(json: result).end()
                    } catch {
                        Log.error("Error sending response")
                    }
                } else {
                    Log.warning("Could not find the item")
                    response.status(HTTPStatusCode.badRequest)
                    return
                }
                
            }
        } catch {
            response.status(HTTPStatusCode.badRequest)
        }
        
    }
    
    /**
     Handle options
     */
    router.options("/*") {
        request, response, next in
        
        response.setHeader("Access-Control-Allow-Headers", value: "accept, content-type")
        response.setHeader("Access-Control-Allow-Methods", value: "GET,HEAD,POST,DELETE,OPTIONS,PUT,PATCH")
        
        response.status(HTTPStatusCode.OK)
        
        next()
    }
    
    /**
     Add a todo list item
     */
    router.post("/") {
        request, response, next in
        
        guard let body = request.body else {
            response.status(HTTPStatusCode.badRequest)
            Log.error("No body found in request")
            return
        }
        
        guard case let .json(json) = body else {
            response.status(HTTPStatusCode.badRequest)
            Log.error("Body is invalid JSON")
            return
        }
        
        let title = json["title"].stringValue
        let order = json["order"].intValue
        let completed = json["completed"].boolValue
        
        Log.info("Received \(title)")
        
        do {
            try todos.add(title: title, order: order, completed: completed) {
                
                newItem in
                
                let result = JSON(newItem.serialize())
                
                do {
                    try response.status(HTTPStatusCode.OK).send(json: result).end()
                } catch {
                    Log.error("Error sending response")
                }
                
            }
        } catch {
            response.status(HTTPStatusCode.badRequest)
        }
    }
    
    router.post(config.firstPathSegment + "/:id") {
        request, response, next in
        
        guard let id = request.params["id"] else {
            response.status(HTTPStatusCode.badRequest)
            Log.error("id parameter not found in request")
            return
        }
        
        guard let body = request.body else {
            response.status(HTTPStatusCode.badRequest)
            Log.error("No body found in request")
            return
        }
        
        guard case let .json(json) = body else {
            response.status(HTTPStatusCode.badRequest)
            Log.error("Body is invalid JSON")
            return
        }
        
        let title = json["title"].stringValue
        let order = json["order"].intValue
        let completed = json["completed"].boolValue
        
        do {
            try todos.update(id: id, title: title, order: order, completed: completed) {
                
                newItem in
                
                let result = JSON(newItem!.serialize())
                
                response.status(HTTPStatusCode.OK).send(json: result)
                
            }
            
        } catch {
            response.status(HTTPStatusCode.badRequest)
        }
    }
    
    /**
     Patch or update an existing Todo item
     */
    router.patch(config.firstPathSegment + "/:id") {
        request, response, next in
        
        guard let id = request.params["id"] else {
            response.status(HTTPStatusCode.badRequest)
            Log.error("id parameter not found in request")
            return
        }
        
        guard let body = request.body else {
            response.status(HTTPStatusCode.badRequest)
            Log.error("No body found in request")
            return
        }
        
        guard case let .json(json) = body else {
            response.status(HTTPStatusCode.badRequest)
            Log.error("Body is invalid JSON")
            return
        }
        
        let title = json["title"].stringValue
        let order = json["order"].intValue
        let completed = json["completed"].boolValue
        
        do {
            try todos.update(id: id, title: title, order: order, completed: completed) {
                
                newItem in
                
                if let newItem = newItem {
                    
                    let result = JSON(newItem.serialize())
                    
                    do {
                        try response.status(HTTPStatusCode.OK).send(json: result).end()
                    } catch {
                        Log.error("Error sending response")
                    }
                }
                
                
            }
        } catch {
            response.status(HTTPStatusCode.badRequest)
        }
    }
    
    ///
    /// Delete an individual todo item
    ///
    router.delete(config.firstPathSegment + "/:id") {
        request, response, next in
        
        Log.info("Requesting a delete")
        
        guard let id = request.params["id"] else {
            Log.warning("Could not parse ID")
            response.status(HTTPStatusCode.badRequest)
            return
        }
        
        do {
            try todos.delete(id) {
                
                do {
                    try response.status(HTTPStatusCode.OK).end()
                } catch {
                    Log.error("Could not produce response")
                }
                
            }
        } catch {
            response.status(HTTPStatusCode.badRequest)
        }
        
    }
    
    /**
     Delete all the todo items
     */
    router.delete("/") {
        request, response, next in
        
        Log.info("Requested clearing the entire list")
        
        do {
            try todos.clear() {
                do {
                    try response.status(HTTPStatusCode.OK).end()
                } catch {
                    Log.error("Could not produce response")
                }
            }
        } catch {
            response.status(HTTPStatusCode.badRequest)
        }
        
        
    }
    
} // end of SetupRoutes()
