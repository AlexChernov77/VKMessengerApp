//
//  SingleChatFabric.swift
//  VkMessenger
//
//  Created by Александр Чернов on 19.01.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import CoreData

class SingleChatFabric
{
    class func setSingleChatDialog ( id: Int64, senderUserID: Int64, title: String, unread: Int64, out: Int64, body: String, userID: String, date: Int64,
          multiChatAvatar: String, context: NSManagedObjectContext ) -> Dialog
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Dialog")
        let predicate = NSPredicate(format: "id=%lld", id)
        fetchRequest.predicate = predicate
        
        let fetchResults = try? context.fetch(fetchRequest) as! [Dialog]
        
        if fetchResults!.count == 0
        {
            let dialog = NSEntityDescription.insertNewObject(forEntityName: "Dialog", into: context) as! Dialog
            
            dialog.id = id
            dialog.body = body
            dialog.date = date
            dialog.out = out
            dialog.senderUserID = senderUserID
            dialog.title = title
            dialog.unread = unread
            dialog.user = userID
            dialog.multiChatPhotoURL = multiChatAvatar
    
            return dialog
        }
        else
        {
            let dialog = fetchResults![0]
            
            dialog.body = body
            dialog.date = date
            dialog.out = out
            dialog.senderUserID = senderUserID
            dialog.title = title
            dialog.unread = unread
            dialog.user = userID
            dialog.multiChatPhotoURL = multiChatAvatar
            
            return dialog
        }
    }
}
