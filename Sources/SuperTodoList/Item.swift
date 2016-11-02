import Foundation
import SwiftyJSON

struct Item {
    let id:       UUID
    let title:    String
}

extension Item: CustomStringConvertible {
    var description: String {
        return title
    }
}

extension Item: Equatable { }

func == (lhs: Item, rhs: Item) -> Bool {
    if  lhs.id          == rhs.id,
        lhs.title       == rhs.title {
        return true
    }
    
    return false

}

extension Item: JSONConvertible {
    init (json: JSON) throws {
        guard let d = json.dictionary,
            let title = d["title"]?.string  else {
                throw ItemError.malformedJSON
        }
        self.id = UUID()
        self.title = title
    }
    var dictionary: [String: Any] {
       
        return ["id": id.uuidString as Any, "title": title as Any]
        
    }
}

enum ItemError: String, Error { case malformedJSON }
