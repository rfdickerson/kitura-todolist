//
//  TaskDatabase.swift
//  SuperTodoList
//
//  Created by Robert F. Dickerson on 9/20/16.
//
//

import Foundation


class TaskDatabase {

    var tasks: [Task] = []
    
    func getAllTasks(oncompletion: ([Task]) -> Void) {
        
        oncompletion(self.tasks)
        
    }
    
    func addTask( task: Task, oncompletion: (Task) -> Void) {
        
        tasks.append(task)
        oncompletion(task)
    }
    
}
