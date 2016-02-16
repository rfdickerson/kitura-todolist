import router
import LoggerAPI

///
/// Sets up all the routes for the Todo List application
///
func setupRoutes( router: Router) {

  ///
  /// Get all the todos
  ///
  router.get("/") {
    request, response, next in

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
