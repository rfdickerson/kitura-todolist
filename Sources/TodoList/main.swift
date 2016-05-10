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

import Kitura
import KituraNet
import KituraSys

import HeliumLogger
import LoggerAPI

import Foundation

import CFEnvironment

///
/// Set up a simple Logger
///
Log.logger = HeliumLogger()

///
/// Set up the app configuration
///

public let config = Configuration()

///
/// The Kitura router
///
let router = Router()

///
/// Setup the database
///
let todos: TodoCollection = TodoCollectionArray()

///
/// Setup routes
///
setupRoutes( router: router, todos: todos )

///
/// Start the server
///
guard let port = config.port else {
    "Could not initialize environment. Exiting..."
    fatalError()
}

let server = HTTPServer.listen(port: port, delegate: router)
Server.run()
Log.info("Server is started on \(config.url).")
