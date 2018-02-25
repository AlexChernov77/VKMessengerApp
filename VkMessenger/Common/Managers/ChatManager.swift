//
//  ChatManager.swift
//  VkMessenger
//
//  Created by Александр Чернов on 08.02.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import Foundation

class ChatManager
{
    
    class func getDataChat (count : Int, offset: Int, peer_id: Int64, success : @escaping () -> Void, failure : @escaping (Int) -> Void)
    {
        let operation = GetChatOperation(count: count, offset: offset, peer_id: peer_id, success: success, failure: failure)
        OperationManager.addOperation(op: operation, cancellingQueue: true)
    }
}
