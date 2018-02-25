//
//  ConnectionLongPollManager.swift
//  VkMessenger
//
//  Created by Александр Чернов on 14.02.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import Foundation
import  SwiftyJSON

class ConnectionLongPollManager
{
    class func connectionLongPoll ()
    {
        API_WRAPPER.getLongPollServer(success: { (jsonResponse) in
            let json = JSON(jsonResponse)
            let server = json["response"]["server"].stringValue
            let key = json["response"]["key"].stringValue
            let ts = json["response"]["ts"].intValue
            
        LongPollManager.connectionLongPoll(server: server, key: key, ts: ts)
        }) { (error) in
            print(error)
        }
    }
}
