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


final class TodoListController {
    
    let todos: TodoListAPI
    let router = Router()
    
    init(backend: TodoListAPI) {
        self.todos = backend
        
        _setupRoutes()
        
    }
    
    private func _setupRoutes() {
        
        let id = "\(config.firstPathSegment)/:id"
        
        router.all("/*", middleware: BodyParser())
        router.all("/*", middleware: AllRemoteOriginMiddleware())
        router.get("/", handler: self.get)
        router.get(id, handler: getByID)
        router.options("/*", handler: getOptions)
        router.post("/", handler: addItem )
        router.post(id, handler: postByID)
        router.patch(id, handler: updateItemByID)
        router.delete(id, handler: deleteByID)
        router.delete("/", handler: deleteAll)
        
        
    }
    
    private func get(request: RouterRequest, response: RouterResponse, next: ()->Void) {
        
        do {
            
            try todos.getAll() {
                todos in
                
                do {
                    let json = JSON(todos.toDictionary())
                    
                    try response.status(HTTPStatusCode.OK).send(json: json).end()
                } catch {
                    
                }
            }
        } catch {
            response.status(.badRequest)
            
        }
        
    }
    
    private func getByID(request: RouterRequest, response: RouterResponse, next: ()->Void) {
        
        guard let id = request.params["id"] else {
            response.status(HTTPStatusCode.badRequest)
            Log.error("Request does not contain ID")
            return
        }
        
        do {
            try todos.get(id) {
                
                item in
                
                if let item = item {
                    
                    let result = JSON(item.toDictionary())
                    
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
    
    private func getOptions(request: RouterRequest, response: RouterResponse, next: ()->Void) {

        response.headers["Access-Control-Allow-Headers"] = "accept, content-type"
        response.headers["Access-Control-Allow-Methods"] = "GET,HEAD,POST,DELETE,OPTIONS,PUT,PATCH"
        
        response.status(HTTPStatusCode.OK)
        
        next()
        
    }
    
    private func addItem(request: RouterRequest, response: RouterResponse, next: ()->Void) {
        
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
                
                let result = JSON(newItem.toDictionary())
                
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
    
    private func postByID(request: RouterRequest, response: RouterResponse, next: ()->Void) {
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
                
                let result = JSON(newItem!.toDictionary())
                
                response.status(HTTPStatusCode.OK).send(json: result)
                
            }
            
        } catch {
            response.status(HTTPStatusCode.badRequest)
        }
        
    }
    
    private func updateItemByID(request: RouterRequest, response: RouterResponse, next: ()->Void) {
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
                    
                    let result = JSON(newItem.toDictionary())
                    
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
    
    private func deleteByID(request: RouterRequest, response: RouterResponse, next: ()->Void) {
        
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
    
    private func deleteAll(request: RouterRequest, response: RouterResponse, next: ()->Void) {
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
    
    
}

