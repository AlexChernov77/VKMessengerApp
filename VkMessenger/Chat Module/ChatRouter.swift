//
//  ChatRouter.swift
//  VkMessenger
//
//  Created by Александр Чернов on 07.02.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import UIKit

class ChatRouter: ChatRouterInterface
{
    let storyboard = UIStoryboard(name: "Chat", bundle: nil)
    

    
    func setUpModule(fromViewController controller: UIViewController)
    {
        
    }
    
    func setUpModule(id : Int64) -> UIViewController
    {
        let chatViewController = storyboard.instantiateViewController(withIdentifier: "chatStoryboard") as! ChatViewController
        print("Айдишник \(id)")
        let presenter = ChatPresenter(peer_id: id)
        let interactor = ChatInteractor()
        
        chatViewController.presenter = presenter

        presenter.view = chatViewController
        presenter.interactor = interactor

        interactor.output = presenter
        return chatViewController
    }
}
