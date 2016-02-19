# Kitura-TodoList
An example using Kitura to develop a Todo-Backend

## Installation

1) Install [Kitura](https://github.com/IBM-Swift/Kitura)

2) Build TodoList application

	`swift build`
	`make`
	
3) Run the TodoList application

	`./.build/debug/TodoList'
	
	
## Usage

To add todo items manually through a POST request, you can run

	curl -H "Content-Type: application/json" -X POST -d '{"title":"Win the Nobel Prize", "order": 0}' http://localhost:8090
