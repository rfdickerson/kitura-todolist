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
    
    func writeJSON() -> Any {
        
        var result: [Any] = []
        for todo in _collection {
            result.append( todo.writeJSON() )
            
        }
        
        return result
        
    }

}

struct TodoItem: JSONSerializable {

    /// ID
    var id: Int

    /// Text to display
    var title: String

    /// Whether completed or not
    var completed: Bool
    
    func writeJSON() -> Any {
        var result = [String: Any]()
        result["id"] = id
        result["title"] = title
        result["completed"] = completed
        return result
    }

}

protocol JSONSerializable {
    func writeJSON() -> Any
}

func serialize(element: Any) -> String {
    switch element {
    case let n as Int:
        return String(n)
    case let n as Bool:
        return String(n)
    case let n as String:
        return "\"\(n)\""
    case let n as [String: Any]:
        var result = "{"
        for (key,value) in n {
            let v = serialize(value)
            result += "\(key): \(v), "
        }
        result += "}"
        return result
    case let n as JSONSerializable:
        return serialize(n.writeJSON())
    case let n as Array<TodoItem>:
        print("array")
        let elements = n.map(serialize).joinWithSeparator(",")
        var result = "["
        result += elements
        result += "]"
        return result
        /*var result = ""
        for i in n {
            result += serialize(i)
            result += ", "
        }
        return result
        */
    default:
        let m = Mirror(reflecting: element)
        print (m.subjectType)
        return "can't serialize"
    }
    
}
