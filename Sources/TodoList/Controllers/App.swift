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

import KituraRouter
import KituraNet

import LoggerAPI
import SwiftyJSON

///
/// Custom middleware that allows Cross Origin HTTP requests
/// This will allow wwww.todobackend.com to communicate with your server
///
class AllRemoteOriginMiddleware: RouterMiddleware {
    func handle(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        
        Log.info("Adding response header 'Access-Control-Allow-Origin: *'")
        
        response.setHeader("Access-Control-Allow-Origin", value: "*")
        // response.setHeader("Access-Control-Allow-Headers", value: "Origin, X-Requested-With, Content-Type, Accept")
        
        response.setHeader("Access-Control-Allow-Headers", value: "accept, content-type")
        response.setHeader("Access-Control-Allow-Methods", value: "GET,HEAD,POST,DELETE,OPTIONS,PUT")
        
        
        next()
    }
}

///
/// Sets up all the routes for the Todo List application
///
func setupRoutes(router: Router, todos: TodoCollection) {

    router.use("/*", middleware: BodyParser())
    
    router.use("/*", middleware: AllRemoteOriginMiddleware())

    
    router.all("/") {
        _, _, next in
        
        next()
    }
        
    ///
    /// Get all the todos
    ///
    router.get("/") {
        request, response, next in

        let json = JSON(TodoCollectionArray.serialize(todos.getAll()))

        response.status(HttpStatusCode.OK).sendJson(json)

        next()
    }

   
    
    ///
    /// TODO:: Get a todo by ID
    ///
    router.get("/:id") {
        request, response, next in

        next()
    }

    ///
    /// Add a todo list item
    ///
    router.post("/") {
        request, response, next in

        if let body = request.body {

            if let json = body.asJson() {

                let title = json["title"].stringValue
                let order = json["order"].intValue
                let completed = json["completed"].boolValue

                let newItem = todos.add(title, order: order, completed: completed)

                let result = JSON(newItem.serialize())

                response.status(HttpStatusCode.OK).sendJson(result)

            }
        } else {
            Log.warning("No body")
            response.status(HttpStatusCode.BAD_REQUEST)
        }

        // next()
  }
    
    router.post("/:id") {
        request, response, next in
        
        let id: String? = request.params["id"]
        
        if let body = request.body {
            
            if let json = body.asJson() {
                
                let title = json["title"].stringValue
                let order = json["order"].intValue
                let completed = json["completed"].boolValue
                
                let newItem = todos.update(id!, title: title, order: order, completed: completed)
                
                let result = JSON(newItem!.serialize())
                
                response.status(HttpStatusCode.OK).sendJson(result)
                
            }
        } else {
            Log.warning("No body")
            response.status(HttpStatusCode.BAD_REQUEST)
        }

        
        
    }

  ///
  /// TODO: Mark the todo item as done
  ///
  router.put("/:id") {
    request, response, next in

    
    next()

  }

  

  ///
  /// Delete an individual todo item
  ///
  router.delete("/todos/:id") {
    request, response, next in
    
    Log.info("Requesting a delete")
    
    let id: String? = request.params["id"]
    
    if let id = id {
        todos.delete(id)
    } else {
        Log.warning("Could not parse ID")
    }
    
    do {
        try response.send("deleted").end()
    } catch {
    
    
    }
    // next()

  }
    
    ///
    /// Delete all the todo items
    ///
    router.delete("/") {
        request, response, next in
        
        Log.info("Requested clearing the entire list")
        
        todos.clear()
        
        next()
        
    }

}
