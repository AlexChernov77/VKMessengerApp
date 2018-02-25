//
//  LongPollManager.swift
//  VkMessenger
//
//  Created by Александр Чернов on 14.02.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData


class LongPollManager
{
    class func connectionLongPoll (server: String, key: String, ts: Int)
    {
        
        let context = CoreDataManager.sharedInstance.getBackgroudContext()
        let set = NSMutableSet()
        API_WRAPPER.connectToLongPoll(server: server, key: key, ts: ts, success: { (jsonResponse) in
            
            let new_ts = jsonResponse["ts"].intValue
            
            if new_ts != 0
            {
                let updates = jsonResponse["updates"].arrayValue
                
                for update in updates
                {
                    if update[0] == 4
                    {
                        let message_id = update[1].int64Value
                        let mask = decodeMask(i: update[2].intValue)
                        var chat_id = update[3].int64Value
                        let timestamp = update[4].doubleValue
                        let body = update[5].stringValue
                        let out = mask[1] == 1 ? 1 : 0
                        let read_state = mask[0] == 1 ? 1 : 0
                        
                        let message = ChatFabric.setChat(id: message_id, idUser: chat_id, date: Date(timeIntervalSince1970: timestamp), body: body, out: Int64(out), read_state: Int64(read_state), context: context)
                        
                        
                        set.add(message)
                        print("Чат айди \(chat_id)")
                            if chat_id > 2000000000
                            {
                               chat_id = chat_id - 2000000000
                            }
                        
                        SingleChatFabric.addMessages(dialogID: chat_id, messagesSet: set, context: context)
                        SingleChatFabric.setSnippet(dialog_id: chat_id, date: Date(timeIntervalSince1970: timestamp), body: body, context: context)
                        
                        _ =  try? context.save()
                    }
                }
                LongPollManager.connectionLongPoll(server: server, key: key, ts: new_ts)
            }
        }) { (error) in
            print(error)
        }
    }
    
    class func decodeMask(i: Int)-> [Int] {
        let array = [1,2,4,8,16,32,64,128,256,512]
        var binary = [Int]()
        for b in array {
            if i&b == 0 {
                binary.append(0)
            } else {
                binary.append(1)
            }
        }
        return binary
    }

}

