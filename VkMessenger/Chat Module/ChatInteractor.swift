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

    weak var output: ChatInteractorOutput?
    func getData(offset: Int, count: Int, peer_id: Int64)
    {
        ChatManager.getDataChat(count: count, offset: offset, peer_id: peer_id, success: {
            CoreDataManager.sharedInstance.save()
            print("Главный контекст сохранен")
                self.output?.success()
        }) { (error) in
            self.output?.failure(error: error)
        }
    }
    
    func sendMessage(peer_id: Int64, random_id: Int, message: String)
    {
        SendMessageManager.sendMessage(peer_id: peer_id, message: message, random_id: random_id, success: {
            CoreDataManager.sharedInstance.save()
            self.output?.sendMessageSuccess()
        }) { (error) in
            self.output?.failure(error: error)
        }
    }
}
