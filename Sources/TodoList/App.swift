import router
import net

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

    do {
        
        
        //let json = JSON(todos.writeJSON())
        
        //try response.status(HttpStatusCode.OK).sendJson(json).end()
        
    } catch {
        Log.error("Failed to send response to client")
    }
    
    next()
  }

  ///
  /// Get a todo by ID
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

  }

  ///
  ///
  ///
  router.put("/:id") {
    request, response, next in
  }

  ///
  /// Delete all the todo items
  ///
  router.delete("/") {
    request, response, next in

  }

  ///
  /// Delete an individual todo item
  ///
  router.delete("/:id") {
    request, response, next in

  }

}
