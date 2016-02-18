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

///
/// Because bridging is not complete in Linux, we must use Any objects for dictionaries
/// instead of AnyObject. The main branch SwiftyJSON takes as input AnyObject, however
/// our patched version for Linux accepts Any.
///
#if os(OSX)
    typealias JSONDictionary = [String: AnyObject]
#else
    typealias JSONDictionary = [String: Any]
#endif

// TodoCollection
//
// TodoCollection defines the DAO for todo lists

protocol TodoCollection {

    ///
    /// Gets the number of todo items in the collection
    ///
    /// - Returns: the number of items
    ///
    var count: Int { get }
    
    ///
    /// Clear all the elements
    ///
    func clear()
    
    ///
    /// Get all the elements in the collection
    ///
    /// - Returns: all the elements in the collection. 
    ///
    func getAll() -> [TodoItem]
    
    ///
    /// Transforms the array of structs to arrays of dictionaries
    /// *Note* SwiftyJSON requires simple types for serialization.
    ///
    /// - Returns: an array of dictionaries with todo item information
    ///
    func serialize() -> [JSONDictionary]
    
    ///
    /// Add an item at a position in the list
    ///
    /// - Parameter title: the description text
    /// - Parameter order: the order in the list
    ///
    /// - Returns: the id for the newly created item
    ///
    func add(title: String, order: Int) -> Int
    
    ///
    /// Delete todo item by id
    ///
    /// - Parameter id: the unique ID for the todo item
    ///
    func delete(id: Int)
    
}

