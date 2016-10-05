import Foundation

struct TodoItem {

    let id:       UUID
    let title:    String
    
}

extension TodoItem: Equatable { }

func == (lhs: TodoItem, rhs: TodoItem) -> Bool {
    if  lhs.id          == rhs.id,
        lhs.title       == rhs.title {
        return true
    }
    
    return false

}

extension TodoItem: JSONConvertible {
    var dictionary: [String: Any] {
        return [
            "id"      : "\(id)",
            "title"   : title,
        ]
    }
}
