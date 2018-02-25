//
//  SendMessageOperation.swift
//  VkMessenger
//
//  Created by Александр Чернов on 14.02.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import Foundation
import CoreData

class SendMessageOperation: Operation
{
    
    var success: () -> Void
    var failure: (Int) -> Void
    var message: String
    var peer_id: Int64
    var random_id: Int
    
    init(peer_id: Int64, message: String, random_id: Int, success: @escaping () -> Void, failure: @escaping (Int) -> Void)
    {
        self.message = message
        self.peer_id = peer_id
        self.random_id = random_id
        self.success = success
        self.failure = failure
    }
    
    override func main()
    {
     let semaphore = DispatchSemaphore(value: 0)
     let backgroundContext = CoreDataManager.sharedInstance.getBackgroudContext()
     let messageSet = NSMutableSet()
        API_WRAPPER.sendMessage(peer_id: peer_id, message: message, random_id: random_id, success: { (jsonResponse) in
            
        let message_id = jsonResponse["response"].int64Value

//            let dialog_id = self.getDialogID(id: self.peer_id)
//           let message = ChatFabric.setChat(id: message_id, idUser: dialog_id, date: Date(), body: self.message, out: 1, read_state: 0, context: backgroundContext)
//            messageSet.add(message)
//            SingleChatFabric.addMessages(dialogID: dialog_id, messagesSet: messageSet, context: backgroundContext)
//            SingleChatFabric.setSnippet(dialog_id: dialog_id, context: backgroundContext)
            _ =  try? backgroundContext.save()
            self.success()
            _ =  semaphore.signal()
        }) { (error) in
            print(error)
            self.failure(error)
          _ =  semaphore.signal()
        }
       _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
    
    private func getDialogID ( id : Int64 ) -> Int64
    {
        print("текущий айди \(id)")
        if id > 2000000000
        {
            return id - 2000000000
        }
        return id
    }
}
