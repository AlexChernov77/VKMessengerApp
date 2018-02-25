//
//  UsersFabrique.swift
//  VkMessenger
//
//  Created by Александр Чернов on 19.01.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import CoreData

class UsersFabrique
{
    class func setUsers (id: String, avatarURL: String, name: String, miniAvatarURL: String , context: NSManagedObjectContext ) -> User
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let predicate = NSPredicate(format: "id=%@", id)
        fetchRequest.predicate = predicate
        
        let fetchResults = try? context.fetch(fetchRequest) as! [User]
        
        if fetchResults!.count == 0
        {
            let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
//            let users = User(context: context)
//            users.id = 1
            user.id = id
            user.avatarURL = avatarURL
            user.name = name
            user.miniAvatarURL = miniAvatarURL
            return user
            
        }
        else
        {
            let user = fetchResults![0]
            
            user.avatarURL = avatarURL
            user.name = name
            user.miniAvatarURL = miniAvatarURL
            return user
        }
    }
    
    class func getUser ( id : Int64 , context : NSManagedObjectContext ) -> User?
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let predicate = NSPredicate(format: "id=%@", id)
        fetchRequest.predicate = predicate
        
        let fetchResults = try? context.fetch(fetchRequest) as! [User]
        
        return fetchResults!.count == 0 ? nil : fetchResults![0]
    }
    
}

