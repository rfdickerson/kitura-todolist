import Foundation
import SwiftyJSON

protocol JSONConvertible {
    var dictionary: [String: Any] {get}
    init(json: JSON) throws
}

extension Array where Element : JSONConvertible {
    var dictionary: [[String: Any]] {
        return self.map { $0.dictionary }
    }
}
