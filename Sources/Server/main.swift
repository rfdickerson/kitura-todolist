import Kitura
import HeliumLogger

import SuperTodoList

HeliumLogger.use()

let superTodoList = SuperTodoList()

Kitura.addHTTPServer(onPort: 8090, with: superTodoList.router)
Kitura.run()
