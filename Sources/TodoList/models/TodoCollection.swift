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

    var count: Int { get }

    func clear()
 
    func getAll() -> [TodoItem]
 
    static func serialize(items: [TodoItem]) -> [JSONDictionary]

    func add(title: String, order: Int, completed: Bool) -> TodoItem

    func update(id: String, title: String?, order: Int?, completed: Bool?) -> TodoItem?

    func delete(id: String)
    
}

