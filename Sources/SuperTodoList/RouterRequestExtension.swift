//
//  RouterRequestExtension.swift
//  SuperTodoList
//
//  Created by Robert F. Dickerson on 9/20/16.
//
//

import Foundation
import Kitura
import SwiftyJSON


extension RouterRequest {

    var json: JSON? {
        
        guard let body = self.body else {
            return nil
        }
        
        guard case let .json(json) = body else {
            return nil
        }
        
        return json
   
    }

}
