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

let post = TodoItem(id: 1, title: "Write Blog Post", completed: false)
let post2 = TodoItem(id: 2, title: "Implement JSON Serializer", completed: true)
todos.add(post)
todos.add(post2)

//let b = JSON(todos.getAll())
//print(b.description)

let json = serialize(todos.getAll() )
Log.info(json)

setupRoutes( router, todos: todos )

///
/// Listen to port 8090
///
let server = HttpServer.listen(8090, delegate: router)

Server.run()
