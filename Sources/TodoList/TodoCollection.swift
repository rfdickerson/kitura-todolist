import SwiftyJSON

class TodoCollection {

  private var _collection: [TodoItem] = []

  init() {}

  func clear() {

    _collection.removeAll()

  }

  func getAll() -> [TodoItem]  {

    return _collection

  }

  func add(post: TodoItem) {

    _collection.append(post)

  }

}

struct TodoItem: AnyObject {

  /// ID
  var id: Int

  /// Text to display
  var title: String

  /// Whether completed or not
  var completed: Bool

}
