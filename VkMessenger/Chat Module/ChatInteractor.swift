//
//  ChatInteractor.swift
//  VkMessenger
//
//  Created by Александр Чернов on 07.02.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import Foundation


class ChatInteractor: ChatInteractorInput
{

    var output: ChatInteractorOutput?
    var idChatArray = NSArray()
    var chats = NSMutableArray()
    func getData(offset: Int, count: Int, peer_id: Int64)
    {
        ChatManager.getDataChat(count: count, offset: offset, peer_id: peer_id, success: { array in
            self.idChatArray = array
            CoreDataManager.sharedInstance.save()
            print("Главный контекст сохранен")
            self.setChatModel()
            self.output?.success(array: self.chats)
        }) { (error) in
            self.output?.failure(error: error)
        }
    }
    
    func setChatModel()
    {
        for chat in idChatArray
        {
            let model = ChatFabric.getChat(id: chat as! Int64, context: CoreDataManager.sharedInstance.getMainContext())
            let chatModels = ChatModel(id: (model?.id)!, date: (model?.date)!, body: (model?.body)!, out: (model?.out)!, read_state: (model?.read_state)!)
            
            self.chats.add(chatModels)
        }
    }

}
