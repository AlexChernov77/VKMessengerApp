//
//  DialogsListRouter.swift
//  VkMessenger
//
//  Created by Александр Чернов on 04.02.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import Foundation
import UIKit

class DialogsListRouter: DialogsListRouterInterface {

    
    private let storyboard = UIStoryboard(name: "DialogsList", bundle: nil)
    weak var rootModuleController: UIViewController?
    var chatRouter: ChatRouter = ChatRouter()
    
    func showChat(dialog : Dialog)
    {
        rootModuleController?.navigationController?.pushViewController(chatRouter.setUpModule(dialog: dialog), animated: true)
    }
    
    func setUpModule(fromViewController controller: UIViewController)
    {
        
    }
    
    func setUpModule() -> UIViewController {
        let initialController = storyboard.instantiateViewController(withIdentifier: "dialogsList") as! DialogsListViewController
        
        rootModuleController = initialController
        let presenter = DialogsListPresenter()
        let interactor = DialogsListInteractor()
        
        initialController.presenter = presenter
        
        presenter.view = initialController
        
        presenter.interactor = interactor
        interactor.output = presenter
        presenter.viewFrc = initialController
        
        
        
        initialController.router = self
        
        return initialController
    }
}
