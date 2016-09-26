//
//  StringValuePairConvertible.swift
//  SuperTodoList
//
//  Created by Robert F. Dickerson on 9/20/16.
//
//

import Foundation

typealias StringValuePair = [String: Any]

protocol StringValuePairConvertible {
    var stringValuePairs: StringValuePair {get}
}

extension Array where Element : StringValuePairConvertible {
    var stringValuePairs: [StringValuePair] {
        return self.map { $0.stringValuePairs }
    }
}
