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
 
import XCTest

@testable import TodoList

#if os(Linux)

	extension TodoCollectionTests : XCTestCaseProvider {
		var allTests : [(String, () throws -> Void)] {
			return [
				("testAddItem", testAddItem),
				("testRemoveItem", testRemoveItem)
			]
		}
	}
#endif

class TodoCollectionTests: XCTestCase {

	func testAddItem() {

		let todos = TodoCollectionArray(baseURL: "http://localhost:8080/todos")

		todos.add("Reticulate splines", order: 0, completed: true)

		XCTAssertEqual(todos.count, 1, "There must be 1 element in the collection")

		todos.add("Herd llamas", order: 1, completed: false)

		XCTAssertEqual(todos.count, 2, "There must be 2 elements in the collection")

	}

	func testRemoveItem() {

		let todos = TodoCollectionArray(baseURL: "http://localhost:8080/todos")

		let newitem = todos.add("Reticulate splines", order: 0, completed: true)

		XCTAssertEqual(todos.count, 1, "There must be 1 element in the collection")

		todos.delete(newitem.id)

		XCTAssertEqual(todos.count, 0, "There must be 0 element in the collection after delete")

	}

}