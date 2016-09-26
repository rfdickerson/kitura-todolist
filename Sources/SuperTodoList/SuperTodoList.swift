/**
 Copyright IBM Corporation 2016
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Kitura
import LoggerAPI
import SwiftyJSON
import Dispatch
import Foundation

public class SuperTodoList {
    public let router = Router()
    
    let taskDatabase = TaskDatabase()
    
    let queue = DispatchQueue(label: "com.example.todo")
    
    public init() {
        router.all("*", middleware: BodyParser())
        router.get("/v1/tasks", handler: handleGetTasks)
        router.post("/v1/tasks", handler: handleAddTask)
        
        taskDatabase.addTask(
            task: Task(id: UUID(),
                 description: "Buy candy",
                 createdAt: Date(),
                 isCompleted: false)
        ) { _ in}
    }
    
}


extension SuperTodoList {
    
    func handleGetTasks(request: RouterRequest,
                        response: RouterResponse,
                        next: @escaping() -> Void) throws
    {
        
        Log.info("Hello!")
        
        taskDatabase.getAllTasks { tasks in
        response.status(.OK).send(json: JSON(tasks.stringValuePairs))
        next()
        
        }
    }
    
    func handleAddTask(request: RouterRequest,
                       response: RouterResponse,
                       next: @escaping() -> Void) throws
    {
     
        guard let json = request.json else {
            response.status(.badRequest)
            next()
            return
        }
        
        let description = json["description"].stringValue
        
        
        let newTask = Task(id: UUID(), description: description, createdAt: Date(), isCompleted: false)
        
        queue.sync {
            
            taskDatabase.addTask(task: newTask) { task in
                
                Log.info("Adding a task!")
                
                response.status(.OK).send("Added a task")
                next()
            }
            
            
        }
        
        
    }
    
    
}




