# Kitura-TodoList

*An example using Kitura to develop the backend for a todo list organizer*

## Installation

1) Install [Kitura](https://github.com/IBM-Swift/Kitura)

2) Build TodoList application

	`swift build`
	`make`
	
3) Run the TodoList application

	`./.build/debug/TodoList'
	
	
## Usage

Open up your browser, and view: 

   [http://www.todobackend.com/client/index.html?http://localhost:8090](http://www.todobackend.com/client/index.html?http://localhost:8090)

To add todo items manually through a POST request, you can run

	curl -H "Content-Type: application/json" -X POST -d '{"title":"Win the Nobel Prize", "order": 0}' http://localhost:8090
