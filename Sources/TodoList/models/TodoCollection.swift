/**
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import sys
import LoggerAPI
import SwiftyJSON

import Foundation

#if os(OSX)
    typealias JSONDictionary = [String: AnyObject]
#else
    typealias JSONDictionary = [String: Any]
#endif


// MARK: TodoCollection

class TodoCollection {

    ///
    /// Ensure in order writes to the collection
    ///
    static let writingQueue = Queue(type: .SERIAL, label: "Writing Queue")
    
    var idCounter: Int = 0
    private var _collection: [TodoItem] = []

    init() {}
    
    var count: Int {
        get {
            return _collection.count
        }
        set {}
    }
    
    func clear() {

        _collection.removeAll()

    }

    func getAll() -> [TodoItem]  {

        return _collection

    }
    
    func serialize() -> [JSONDictionary] {
       
        return _collection.map { $0.serialize() }
       
    }

    func add(post: TodoItem) {
        
        TodoCollection.writingQueue.queueSync() {
            
            self._collection.append(post)
            
        }

    }
    
    func add(title: String, order: Int) -> Int {
        
        let newItem = TodoItem(id: count,
            order: order,
            title: title,
            completed: false)
        
        idCounter+=1
        
        TodoCollection.writingQueue.queueSync() {
            self._collection.append(newItem)
        }
        
        return idCounter-1
    }
    
    func delete(id: Int) {
        
        
        
    }
    
    func reorderItems() {
        var c = 0
        for i in 0..<_collection.count {
            _collection[i].order = i
        }
    }
    
}

