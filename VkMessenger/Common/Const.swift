//
//  Const.swift
//  VkMessenger
//
//  Created by Александр Чернов on 22.01.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import Foundation

class Const
{
    class URLConst
    {
        static let kBaseURL = "https://api.vk.com/method/"
        
        class Scripts
        {
            static let kMethodMessage = "messages.getDialogs"
            static let kMethodUser = "users.get"
            static let kChat = "messages.getHistory"
            static let kSendMessage = "messages.send"
            static let kGetLongPoll = "messages.getLongPollServer"
        }
        
        class Arguments
        {
            static let kCount : NSString = "count"
            static let kFields: NSString = "fields"
            static let kOrder: NSString = "order"
            static let kOffset: NSString = "offset"
            static let kAccessToken: NSString = "access_token"
            static let kUser : NSString = "user_ids"
            static let kPeer_id: NSString = "peer_id"
            static let kMessage: NSString = "message"
            static let kRandom_id: NSString = "random_id"
        }
        
    }
}
