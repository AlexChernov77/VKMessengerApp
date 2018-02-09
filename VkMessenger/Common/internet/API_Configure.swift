//
//  API_Configure.swift
//  VkMessenger
//
//  Created by Александр Чернов on 17.01.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import Foundation

class API_Configurator {
 
    class func createRequest(forBaseURL baseURL: String, andMethod method: String, withParametrs parametrs: NSDictionary) -> NSURLRequest
    {
        var requestString = baseURL + method + "?"
        
        let keysArray = parametrs.allKeys as! [String]
        
        for i in 0..<keysArray.count
        {
            let key = keysArray[i]
            let value = parametrs[key] as! String
            
            
            requestString += "\(key)=\(value)&"
        }
        
        requestString += "v=5.71"
        
        print("\n\n\n строка запроса - \(requestString)\n\n\n")
        
        let request = NSMutableURLRequest ()
        request.httpMethod = "GET"
        request.url = URL(string: requestString)
        
        return request
    }

    
}
