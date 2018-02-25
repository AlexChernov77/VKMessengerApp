//
//  SendMessageManager.swift
//  VkMessenger
//
//  Created by Александр Чернов on 14.02.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import Foundation

class SendMessageManager
{
    class func sendMessage (peer_id : Int64, message: String, random_id: Int, success : @escaping () -> Void, failure : @escaping (Int) -> Void)
    {
        let operation = SendMessageOperation(peer_id: peer_id, message: message, random_id: random_id, success: success, failure: failure)
        
        OperationManager.addOperation(op: operation, cancellingQueue: true)
    }
}
