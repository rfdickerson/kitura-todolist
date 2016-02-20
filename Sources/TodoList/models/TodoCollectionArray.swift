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

import KituraSys
import LoggerAPI
import SwiftyJSON

import Foundation


// MARK: TodoCollectionArray

class TodoCollectionArray: TodoCollection {

    var baseURL: String
    
    ///
    /// Ensure in order writes to the collection
    ///
    let writingQueue = Queue(type: .SERIAL, label: "Writing Queue")

    ///
    /// Incrementing variable used for new index values
    ///
    var idCounter: Int = 0

    ///
    /// Internal storage of TodoItems as a Dictionary
    ///
    private var _collection = [String: TodoItem]()
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }

    var count: Int {
        return _collection.keys.count
    }

    func clear() {

        writingQueue.queueSync() {
            self._collection.removeAll()
        }

    }

    func getAll() -> [TodoItem]  {

        return [TodoItem](_collection.values)

    }

    static func serialize(items: [TodoItem]) -> [JSONDictionary] {

        return items.map { $0.serialize() }

    }


    func add(title: String, order: Int, completed: Bool) -> TodoItem {

        var original: String
        original = String(self.idCounter)
        
        let newItem = TodoItem(id: original,
            order: order,
            title: title,
            completed: false,
            url: self.baseURL + "/" + original
        )

        writingQueue.queueSync() {

            self.idCounter+=1

            self._collection[original] = newItem

        }

        Log.info("Added \(title)")

        return newItem

    }
    
    /// 
    /// Update an element by id
    ///
    /// - Parameter id: id for the element
    /// - 
    func update(id: String, title: String?, order: Int?, completed: Bool?) -> TodoItem? {
        
        // search for element
        
        let oldValue = _collection[id]
        
        if let oldValue = oldValue {
            
            // use nil coalescing operator
            
            let newValue = TodoItem( id: id,
                order: order ?? oldValue.order,
                title: title ?? oldValue.title,
                completed: completed ?? oldValue.completed,
                url: oldValue.url
            )
            
            _collection.updateValue(newValue, forKey: id)
            
            return newValue
            
        } else {
            Log.warning("Could not find item in database with ID: \(id)")
        }
        
        return nil
    }

    func delete(id: String) {

        writingQueue.queueSync() {

            self._collection.removeValueForKey(id)
        }

    }
    
}
