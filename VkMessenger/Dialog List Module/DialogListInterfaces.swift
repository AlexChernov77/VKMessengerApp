//
//  DialogListInterfaces.swift
//  VkMessenger
//
//  Created by Александр Чернов on 04.02.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import Foundation
import UIKit

protocol DialogsListViewInterface: class {
    func reloadData()
    func handleInternetError(error: String)
}

protocol DialogsListPresenterInterface: class {
    func viewDidLoad()
    func viewWillAppear(animated: Bool)
    func viewDidAppear(animated: Bool)
    func numberOfEntities() -> Int
    func entityAt(index: IndexPath)-> Any?
}

protocol DialogsListInteractorInput: class {
    func getData()
}

protocol DialogsListInteractorOutput: class {
    func success()
    func failure(error: Int)
}

protocol DialogsListRouterInterface: class {
    func showChat(id: Int64)
    func setUpModule(fromViewController controller: UIViewController)
    func setUpModule()-> UIViewController
}
