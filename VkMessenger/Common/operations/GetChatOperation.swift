//
//  GetChatOperation.swift
//  VkMessenger
//
//  Created by Александр Чернов on 08.02.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class GetChatOperation: Operation
{
    var count: Int
    var offset: Int
    var peer_id: Int64
    var success: () -> Void
    var failure: (Int) -> Void
    static var arrayID = NSArray()
    var urlsessionDataTask : URLSessionDataTask?
    init(count: Int, offset: Int, peer_id: Int64, success: @escaping () -> Void, failure: @escaping (Int) -> Void)
    {
        self.count = count
        self.offset = offset
        self.peer_id = peer_id
        self.success = success
        self.failure = failure
    }
    
    override func cancel() {
        urlsessionDataTask?.cancel()
    }
    
    override func main() {
       
        let semaphore = DispatchSemaphore(value: 0)
        let backGroundContext = CoreDataManager.sharedInstance.getBackgroudContext()
        urlsessionDataTask = API_WRAPPER.getChat(offset: offset, count: count, peer_id: peer_id, success: { (jsonResponse) in
            
            let rawItems = jsonResponse["response"]
            let items = rawItems["items"].arrayValue
            let set = NSMutableSet()
            for chat in items
            {
                let date = chat["date"].doubleValue
                let body = chat["body"].stringValue
                let id = chat["id"].int64Value
                let unread = chat["read_state"].int64Value
                let out = chat["out"].int64Value
                let idUser = chat["from_id"].int64Value
                
                let message = ChatFabric.setChat(id: id, idUser: idUser, date: Date(timeIntervalSince1970: date), body: body, out: out, read_state: unread, context: backGroundContext)
                
                 set.add(message)
            }
            
            if self.isCancelled
            {
                self.success()
            }
            else
            {
                let dialogID = self.getDialogID(id: self.peer_id)
                SingleChatFabric.addMessages(dialogID: dialogID, messagesSet: set, context: backGroundContext)
                _ =  try? backGroundContext.save()
                self.success()
            }
            
            _ = semaphore.signal()

        }, failure: { (error) in
            self.failure(error)
            _ = semaphore.signal()
        })
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
