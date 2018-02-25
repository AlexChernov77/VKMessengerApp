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
    
    func setUpModule( dialog: Dialog) -> UIViewController
    {
        let chatViewController = storyboard.instantiateViewController(withIdentifier: "chatStoryboard") as! ChatViewController
        let presenter = ChatPresenter(dialog: dialog)
        let interactor = ChatInteractor()
        
        chatViewController.presenter = presenter

        presenter.view = chatViewController
        presenter.interactor = interactor
        presenter.viewFrc = chatViewController

        interactor.output = presenter
        return chatViewController
    }
}
