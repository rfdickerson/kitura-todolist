import Foundation

struct TodoListItem {

    let id:       UUID
    let title:    String
    
}

extension TodoListItem: Equatable { }

func == (lhs: TodoListItem, rhs: TodoListItem) -> Bool {
    if  lhs.id          == rhs.id,
        lhs.title       == rhs.title {
        return true
    }
    
    return false

}

extension TodoListItem: JSONConvertible {
    var dictionary: [String: Any] {
        return [
            "id"      : "\(id)",
            "title"   : title,
        ]
    }
}
