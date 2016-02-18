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
let todos: TodoCollection = TodoCollectionArray()

///
/// Add some example data to the database
///
todos.add("Reticulate splines", order: 0)
todos.add("Herd llamas", order: 1)

setupRoutes( router, todos: todos )

///
/// Listen to port 8090
///
let server = HttpServer.listen(8090, delegate: router)

Server.run()
