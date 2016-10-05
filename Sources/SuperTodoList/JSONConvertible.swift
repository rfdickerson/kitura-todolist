import Foundation


protocol JSONConvertible {
    var dictionary: [String: Any] {get}
}

extension Array where Element : JSONConvertible {
    var dictionary: [[String: Any]] {
        return self.map { $0.dictionary }
    }
}
