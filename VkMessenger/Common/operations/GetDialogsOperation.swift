//
//  GetDialogsOperation.swift
//  VkMessenger
//
//  Created by Александр Чернов on 22.01.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class GetDialogsOperation: Operation
{
    var success: () -> Void
    var failure: (Int) -> Void
    var count: Int
    var offSet: Int
    var urlsessionDataTask : URLSessionDataTask?
    var user: User?
    var dialog: Dialog?
    
    init(success: @escaping () -> Void, failure: @escaping (Int) -> Void, count: Int, offSet: Int)
    {
         self.success = success
         self.failure = failure
         self.count = count
         self.offSet = offSet
    }
    
    override func cancel()
    {
        urlsessionDataTask?.cancel()
    }
    
    override func main()
    {
        let semaphore = DispatchSemaphore(value: 0)
       urlsessionDataTask = API_WRAPPER.getJsonDialog(count: count, offset: offSet, succBlock: { (jsonResponse) in
        
            let rawItems = jsonResponse["response"]
            let items = rawItems["items"].arrayValue
            let backGroundContext = CoreDataManager.sharedInstance.getBackgroudContext()
            var userArray = ""
            var usersArray = ""
            var use = ""

            for dialog in items
            {
                let message = dialog["message"]
                
                let chatID = message["chat_id"].int64Value
                var multichatURL = "empty"
                let senderUserID = message["user_id"].int64Value
                let title = message["title"].stringValue
                let unread = message["read_state"].int64Value
                let out = message["out"].int64Value
                var body = message["body"].stringValue
                
                if message["photo_100"] != nil
                {
                    multichatURL = message["photo_100"].stringValue
                }
                let date = message["date"].int64Value
                
                if body == ""
                {
                    let attachment = message["attachments"].arrayValue
                    var tempBody = ""
                    
                    for attach in attachment
                    {
                        let type = attach["type"].stringValue
                        
                        if type == "photo"
                        {
                            tempBody = "Фотография"
                        }
                        if type == "video"
                        {
                            tempBody = "Видеозапись"
                        }
                        if type == "audio"
                        {
                            tempBody = "Аудиозапись"
                        }
                        if type == "doc"
                        {
                            tempBody = "Документ"
                        }
                        if type == "link"
                        {
                            tempBody = "Ссылка"
                        }
                        if type == "market"
                        {
                            tempBody = "Товар"
                        }
                        if type == "market_album"
                        {
                            tempBody = "Подборка товаров"
                        }
                        if type == "wall"
                        {
                            tempBody = "Запись на стене"
                        }
                        if type == "wall_reply"
                        {
                            tempBody = "Комментарий на стене"
                        }
                        if type == "sticker"
                        {
                            tempBody = "Стикер"
                        }
                        if type == "gift"
                        {
                            tempBody = "Подарок"
                        }
                        
                        if body == ""
                        {
                            body = tempBody
                        }
                        else
                        {
                            body = body + ", " + tempBody
                        }
                    }
                }
                
                   /*Мультичат*/
                if chatID != 0
                {
                    
                    let chatUsers = message["chat_active"].arrayValue
                    
                    for usersChat in chatUsers
                    {
                        let user = usersChat.stringValue
                            usersArray = "\(user)"
                            userArray += "\(user),"
//                        print("картинка \(multichatURL)")
                        self.setObject(id: usersArray, chatID: chatID, senderUserID: senderUserID, title: title, unread: unread, out: out, body: body, userID: usersArray, date: date, multiChatAvatar: multichatURL, context: backGroundContext)
                        
                    }
//                    if userArray != ""
//                    {
//                        usersArray.remove(at: usersArray.index(before: usersArray.endIndex))
//                    }
                    
                }
                    /*Single chat*/
                else
                {

                         userArray += "\(senderUserID),"
                          use += "\(senderUserID),"
                    
                    self.setObject(id: String(senderUserID), chatID: senderUserID, senderUserID: senderUserID, title: title, unread: unread, out: out, body: body, userID: String (senderUserID), date: date, multiChatAvatar: multichatURL, context: backGroundContext)
                }
            }
        if userArray != ""
        {
            userArray.remove(at: userArray.index(before: userArray.endIndex))
        }
//        print("массив \(usersArray)")
//        print("массив1 \(userArray)")
            if self.isCancelled
            {
                self.success()
                _ = semaphore.signal()
            }
            else
            {
                self.getUser(userId: userArray, semaphore: semaphore, backgroundContext: backGroundContext)
                
                self.success()
            }
        }) { (error) in
            self.failure(error)
            _ = semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
    
    
    func setObject (id: String, chatID: Int64 ,senderUserID: Int64, title: String, unread: Int64, out: Int64, body: String, userID: String, date: Int64, multiChatAvatar: String, context: NSManagedObjectContext)
    {
        
        self.user = UsersFabrique.setUsers(id: id, avatarURL: "", name: "", context: context)
        self.dialog = SingleChatFabric.setSingleChatDialog(id: chatID, senderUserID: senderUserID, title: title, unread: unread, out: out, body: body, userID: userID, date: date, multiChatAvatar: multiChatAvatar, context: context)
        user?.addToDialogs(dialog!)
        dialog?.addToUsers(user!)
    }
    
    
    func getUser ( userId: String, semaphore : DispatchSemaphore , backgroundContext : NSManagedObjectContext)
    {
        self.urlsessionDataTask = API_WRAPPER.getJsonUser(usersId: userId, succBlock: { (jsonResponse) in
            let users = jsonResponse["response"].arrayValue
            
            for user in users
            {
                    let name = user["first_name"].stringValue + " " + user["last_name"].stringValue
                    let userId = user["id"].int64Value
                    let avatarURL = user["photo_100"].stringValue
//                print("массив3 \(userId)")
             self.user = UsersFabrique.setUsers(id: String(userId), avatarURL: avatarURL, name: name, context: backgroundContext)
            }
            print("Сохранияем бекграундный контекст")
            semaphore.signal()
            _ =  try? backgroundContext.save()
        }) { (error) in
            print(error)
        }
    }
}
