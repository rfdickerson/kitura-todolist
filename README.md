# Kitura To-do List Backend

*An example using the Kitura web framework and HTTP Server to develop a backend for a todo list organizer*

## Tutorial

This project accompanies the tutorial on IBM Developer Works: [Build End-to-End Cloud Apps using Swift with Kitura](https://developer.ibm.com/swift/2016/02/22/building-end-end-cloud-apps-using-swift-kitura/)

## Installation

1. Install the [04-25-DEVELOPMENT Swift toolchain](https://swift.org/download/) 

2. Install Kitura dependencies:

  1. Mac OS X: 
  
    `brew install http-parser pcre2 curl hiredis`
  
  2. Linux (Ubuntu 15.10):
   
    `sudo apt-get install libhttp-parser-dev libcurl4-openssl-dev libhiredis-dev`

3. Build TodoList application

  1. Mac OS X: 
	
	`swift build -Xcc -fblocks -Xswiftc -I/usr/local/include -Xlinker -L/usr/local/lib`
	
  2. Linux:
  
    `swift build -Xcc -fblocks`
	
4. Run the TodoList application:

	`./.build/debug/TodoList`
	
5. Open up your browser, and view: 

   [http://www.todobackend.com/client/index.html?http://localhost:8090](http://www.todobackend.com/client/index.html?http://localhost:8090)


## Tests

  To run unit tests, run:
  
  `swift test`

## License 

This library is licensed under Apache 2.0. Full license text is available in [LICENSE](LICENSE).
