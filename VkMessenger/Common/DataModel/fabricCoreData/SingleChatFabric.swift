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
    class func setSingleChatDialog ( id: Int64, senderUserID: Int64, title: String, unread: Int64, out: Int64, body: String, userID: String, date: Date, multiChatAvatar: String, miniAvatar: String, context: NSManagedObjectContext ) -> Dialog
    {
        var dialog = getDialog(id: id, context: context)
        
        if dialog == nil
        {
            dialog = NSEntityDescription.insertNewObject(forEntityName: "Dialog", into: context) as? Dialog
            
            dialog!.id = id
            dialog!.body = body
            dialog!.date = date
            dialog!.out = out
            dialog!.senderUserID = senderUserID
            dialog!.title = title
            dialog!.unread = unread
            dialog!.user = userID
            dialog!.multiChatPhotoURL = multiChatAvatar
            dialog!.miniAvatar = miniAvatar
    
            return dialog!
        }
        else
        {
            dialog!.body = body
            dialog!.date = date
            dialog!.out = out
            dialog!.senderUserID = senderUserID
            dialog!.title = title
            dialog!.unread = unread
            dialog!.user = userID
            dialog!.multiChatPhotoURL = multiChatAvatar
            dialog!.miniAvatar = miniAvatar
            return dialog!
        }
    }
    
    class func addMessages ( dialogID id: Int64, messagesSet set: NSMutableSet, context : NSManagedObjectContext)
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Dialog")
        let predicate = NSPredicate(format: "id=%lld", id)
        fetchRequest.predicate = predicate
        let fetchResults = try? context.fetch(fetchRequest) as! [Dialog]

        let dialog = fetchResults![0]
        dialog.addToChats(set)
    }
    
    class func hasMessages(id: Int64, context: NSManagedObjectContext) -> Bool
    {
        let dialog = getDialog(id: id, context: context)
        
        if dialog != nil
        {
            if dialog!.chats != nil
            {
                return dialog!.chats!.allObjects.count != 0
            }
            else
            {
                return false
            }
        }
        else
        {
            return false
        }
    }
    
    class func getDialog(id: Int64, context: NSManagedObjectContext) -> Dialog?
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Dialog")
        
//        let request: NSFetchRequest<Dialog> = Dialog.fetchRequest()
        let predicate = NSPredicate(format: "id=%lld", id)
        fetchRequest.predicate = predicate
        let fetchResults = try? context.fetch(fetchRequest) as! [Dialog]

        if fetchResults!.count == 0
        {
            return nil
        }
        else
        {
            return fetchResults![0]
        }
    }
    
    class func setSnippet ( dialog_id: Int64, date: Date, body: String, context: NSManagedObjectContext)
    {
        var dialog = getDialog(id: dialog_id, context: context)
        
        if dialog == nil
        {
            dialog = NSEntityDescription.insertNewObject(forEntityName: "Dialog", into: context) as? Dialog
            
            dialog!.id = dialog_id
            dialog!.body = body
            dialog?.date = date

        }
        else
        {
            dialog!.body = body
            dialog?.date = date
        }
    }
}
