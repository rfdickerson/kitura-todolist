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
/// Sets up all the routes for the Todo List application
///
func setupRoutes(router: Router, todos: TodoCollection) {

    router.use("/*", middleware: BodyParser())

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

                let id = todos.add(title, order: order)

                let result = JSON(["id":id])

                response.status(HttpStatusCode.OK).sendJson(result)

            }
        } else {
            Log.warning("No body")
            response.status(HttpStatusCode.BAD_REQUEST)
        }

        next()
  }

  ///
  /// TODO: Mark the todo item as done
  ///
  router.put("/:id") {
    request, response, next in

    if let body = request.body {
        
        if let json = body.asJson() {
            
            let id = json["id"].intValue
            
            todos.toggle(id)
            
            response.status(HttpStatusCode.OK).send("")
            
        }
    } else {
        Log.warning("No body")
        response.status(HttpStatusCode.BAD_REQUEST)
    }
    
    next()

  }

  ///
  /// Delete all the todo items
  ///
  router.delete("/") {
    request, response, next in

    todos.clear()

    next()

  }

  ///
  /// Delete an individual todo item
  ///
  router.delete("/:id") {
    request, response, next in

    if let body = request.body {

        if let json = body.asJson() {

            let id = json["id"].intValue

            todos.delete(id)
            // return a response

        }
    } else {
        Log.warning("No body")
        // return a response
    }

    next()

  }

}
