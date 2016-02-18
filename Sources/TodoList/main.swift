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

import router
import net
import sys

import HeliumLogger
import LoggerAPI
import SwiftyJSON

import Foundation

///
/// The Kitura router
///
let router = Router()

///
/// Set up a simple Logger
///
Log.logger = HeliumLogger()

///
/// Setup the database
///
let todos = TodoCollection()

//let post = TodoItem(id: 1, title: "Write Blog Post", completed: false)
//let post2 = TodoItem(id: 2, title: "Implement JSON Serializer", completed: true)
todos.add("Write blog post", order: 0)
todos.add("Implement JSON Serialization", order: 1)

//let b = JSON(todos.getAll())
//print(b.description)

//let json = JSON(todos.serialize())

//do {
//    let b = try NSJSONSerialization.data
//}

//Log.info(json.description)

setupRoutes( router, todos: todos )

///
/// Listen to port 8090
///
let server = HttpServer.listen(8090, delegate: router)

Server.run()
