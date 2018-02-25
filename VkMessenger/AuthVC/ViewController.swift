//
//  ViewController.swift
//  VkMessenger
//
//  Created by Александр Чернов on 17.01.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool)
    {
        VKMAuthService.sharedInstance.auth(controller: self, success: {
            
            print("успехи - \(VKMAuthService.sharedInstance.getAccessToken())")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0)
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0)
                {
                    ConnectionLongPollManager.connectionLongPoll()
                    let navController = UINavigationController()
                    let router = DialogsListRouter()
                    navController.setViewControllers([router.setUpModule()], animated: false)
                    self.present(navController, animated: true, completion: nil)
                }
            }
        }, failure: { [weak self] in
            
            let alertController = UIAlertController(title: nil, message: "К сожалению, произошёл обоссамс авторизации. Разработчик уволен", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
            alertController.addAction(action)
            self?.present(alertController, animated: true, completion: nil)
            
            
        })
        super.viewDidAppear(animated)
        VKMAuthService.sharedInstance.success = {
            print("ХЕР")
        }
    }
}

