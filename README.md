# Kitura To-do List Backend

*An example using the Kitura web framework and HTTP Server to develop a backend for a todo list organizer*

[![Build Status](https://travis-ci.org/IBM-Swift/Kitura-TodoList.svg?branch=master)](https://travis-ci.org/IBM-Swift/Kitura-TodoList)

> Supports the 05-03 SNAPSHOT.

## Tutorial

This project accompanies the tutorial on IBM Developer Works: [Build End-to-End Cloud Apps using Swift with Kitura](https://developer.ibm.com/swift/2016/02/22/building-end-end-cloud-apps-using-swift-kitura/)

## Installation

1. Install the [05-03-DEVELOPMENT Swift toolchain](https://swift.org/download/) 

2. Install Kitura dependencies:

  1. Mac OS X: 
  
    `brew install curl`
  
  2. Linux (Ubuntu 15.10):
   
    `sudo apt-get install libcurl4-openssl-dev`

3. Build TodoList application

  1. Mac OS X: 
	
	`swift build`
	
  2. Linux:
  
    	`swift build -Xcc -fblocks`
	
4. Run the TodoList application:

	`./.build/debug/TodoList`
	
5. Open up your browser, and view: 

   [http://www.todobackend.com/client/index.html?http://localhost:8090](http://www.todobackend.com/client/index.html?http://localhost:8090)

## Developing and Running in XCode:

Make sure you are running at least XCode 7.3. 

1. Automatically generate an XCode project from the Package.swift:

  `swift build -X`

2. Open XCode project

  `open TodoList.xcodeproj`

3. Switch the toolchain to the open source version of Swift.

## Tests

  To run unit tests, run:
  
  `swift test`
  
  If you are using XCode, you can run the Test Cases as normal in the IDE.

## License 

This library is licensed under Apache 2.0. Full license text is available in [LICENSE](LICENSE).
