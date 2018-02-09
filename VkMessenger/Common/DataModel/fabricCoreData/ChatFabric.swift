//
//  ChatFabric.swift
//  VkMessenger
//
//  Created by Александр Чернов on 08.02.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import CoreData

class ChatFabric
{
    class func setChat ( id: Int64, idUser: Int64, date: Int64, body: String, out: Int64, read_state: Int64, context: NSManagedObjectContext)
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
        let predicate = NSPredicate(format: "id=%lld", id)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        let fetchResults = try? context.fetch(fetchRequest) as! [Chat]
        
        if fetchResults!.count == 0
        {
            let chat = NSEntityDescription.insertNewObject(forEntityName: "Chat", into: context) as! Chat
            
            chat.id = id
            chat.body = body
            chat.date = date
            chat.out = out
            chat.read_state = read_state
            chat.idUser = idUser

        }
        else
        {
            let chat = fetchResults![0]
            
            chat.body = body
            chat.date = date
            chat.out = out
            chat.read_state = read_state

        }
    }

    class func getChat ( id : Int64 , context : NSManagedObjectContext ) -> Chat?
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
        let predicate = NSPredicate(format: "id=%lld", id)
        fetchRequest.predicate = predicate


        let fetchResults = try? context.fetch(fetchRequest) as! [Chat]
        
        return fetchResults!.count == 0 ? nil : fetchResults![0]
    }
}
