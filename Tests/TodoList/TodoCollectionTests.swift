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
		var allTests: [(String, () throws -> Void)] {
			return [
				("testAddItem", testAddItem),
				("testRemoveItem", testRemoveItem)
			]
		}
	}
#endif

class TodoCollectionTests: XCTestCase {
    let url = "http://localhost:8090/todos"

    func testAddItem() {

        let todos = TodoCollectionArray(baseURL: url)

        let expectation1 = expectation(withDescription: "Add first item")
        todos.add(title: "Reticulate splines", oncompletion: {_ in
            XCTAssertEqual(todos.count, 1, "There must be 1 element in the collection")
            todos.add(title: "Herd llamas", order: 1, completed: true, oncompletion: {_ in
                XCTAssertEqual(todos.count, 2, "There must be 2 elements in the collection")
                expectation1.fulfill()
            })
        })

        waitForExpectations(withTimeout: 5, handler: { error in XCTAssertNil(error, "Timeout") })

    }

    func testRemoveItem() {

        let todos = TodoCollectionArray(baseURL: url)

        let expectation1 = expectation(withDescription: "Remove item")
        todos.add(title: "Reticulate splines", order: 0, completed: true, oncompletion: {newitem in
            XCTAssertEqual(todos.count, 1, "There must be 1 element in the collection")
            todos.delete(newitem.id, oncompletion: { _ in
                XCTAssertEqual(todos.count, 0, "There must be 0 element in the collection after delete")
                expectation1.fulfill()
            })
        })

        waitForExpectations(withTimeout: 5, handler: { error in XCTAssertNil(error, "Timeout") })
    }

}
