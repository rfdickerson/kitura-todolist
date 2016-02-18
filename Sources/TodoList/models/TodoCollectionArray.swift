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


// MARK: TodoCollectionArray

class TodoCollectionArray: TodoCollection {
    
    ///
    /// Ensure in order writes to the collection
    ///
    let writingQueue = Queue(type: .SERIAL, label: "Writing Queue")
    
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
    
    static func serialize(items: [TodoItem]) -> [JSONDictionary] {
        
        return items.map { $0.serialize() }
        
    }
    
    
    func add(title: String, order: Int) -> Int {
        
        if order < 0 {
            
            return -1
        }
        
        let newItem = TodoItem(id: count,
            order: order,
            title: title,
            completed: false)
        
        idCounter+=1
        
        writingQueue.queueSync() {
            
            let index = min(self._collection.count, order)
          
            self._collection.insert( newItem, atIndex: index)
        }
        
        reorderItems()
        
        return idCounter-1
    }
    
    func delete(id: Int) {
        
        _collection = _collection.filter( {
            $0.id != id
            })
        
        reorderItems()
        
    }
    
    private func reorderItems() {
        
        for i in 0..<_collection.count {
            _collection[i].order = i
        }
    }
    
}

