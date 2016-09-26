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




