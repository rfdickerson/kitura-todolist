import router
import net
import sys
import HeliumLogger
import LoggerAPI

///
/// The Kitura router
///
let router = Router()

///
/// Set up a simple Logger
///
Log.logger = HeliumLogger()


setupRoutes( router )

///
/// Listen to port 8090
///
let server = HttpServer.listen(8090, delegate: router)

Server.run()
