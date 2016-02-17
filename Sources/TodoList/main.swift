import router
import net
import sys
import HeliumLogger
import LoggerAPI

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
todos.add(post)

let t = todos.getAll()

let s: NSData

do {

 s = try NSJSONSerialization.dataWithJSONObject(
  t as! [AnyObject],
  options: NSJSONWritingOptions(rawValue: 0))

  if let string = NSString(data: s, encoding: NSUTF8StringEncoding) {
    print (string)
  }

} catch {}

setupRoutes( router )

///
/// Listen to port 8090
///
let server = HttpServer.listen(8090, delegate: router)

Server.run()
