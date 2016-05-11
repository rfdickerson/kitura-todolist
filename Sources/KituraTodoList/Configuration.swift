/**
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation
import CFEnvironment
import SwiftyJSON

import LoggerAPI

public struct Configuration {
    
    let firstPathSegment = "todos"
    
    static let DefaultRedisHost = "localhost"
    static let DefaultRedisPort: UInt16 = 6379
    
    static let DefaultWebHost = "localhost"
    static let DefaultWebPort = 8090
    
    var url: String = Configuration.DefaultWebHost
    var port: Int = Configuration.DefaultWebPort
    
    var redisHost: String = Configuration.DefaultRedisHost
    var redisPort: UInt16 = Configuration.DefaultRedisPort
    
    var redisPassword: String?
    
    init() {
        do {
            let appEnv = try CFEnvironment.getAppEnv()
            port = appEnv.port
            url = appEnv.url
            
            if let redisService = try CFEnvironment.getAppEnv().getService(spec: "Redis by Compose-ph") {
                
                if let credentials = redisService.credentials {
                    redisHost = credentials["public_hostname"].stringValue
                    redisPort = UInt16(credentials["username"].stringValue)!
                    redisPassword = credentials["password"].stringValue
                }
                
                
            } else {
                Log.error("Could not retrieve Redis service.")
            }
            
            //redisOpts?.credentials
            
            // load from cfenv
            
        }
        catch _ {
            Log.error("Could not retrieve CF environment.")
        }
        
        
    }
}