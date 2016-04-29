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
let todos: TodoCollection = TodoCollectionArray(baseURL: "http://localhost:8090/todos")

///
/// Add some example data to the database
///
// todos.add("Reticulate splines", order: 0, completed: false)
// todos.add("Herd llamas", order: 1, completed: false)

setupRoutes( router: router, todos: todos )

///
/// Listen to port 8090
///
do {

    let appEnv = try CFEnvironment.getAppEnv()
    let ip: String = appEnv.bind
    let port: Int = appEnv.port

    let server = HttpServer.listen(port: port, delegate: router)

    Server.run()

    Log.info("Server is started on \(appEnv.url).")

} catch CFEnvironmentError.InvalidValue {
    Log.error("Oops, something went wrong... Server did not start!")
}
