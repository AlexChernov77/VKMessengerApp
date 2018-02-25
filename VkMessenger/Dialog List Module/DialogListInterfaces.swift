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

protocol DialogsListFrcViewChange: class {
    func beginUpdates () -> Void
    func endUpdates () -> Void
    func insert ( at : IndexPath ) -> Void
    func delete ( at : IndexPath ) -> Void
    func move ( from : IndexPath , to : IndexPath ) -> Void
    func update ( at : IndexPath ) -> Void
}

protocol DialogsListPresenterInterface: class {
    func viewDidLoad()
    func viewWillAppear(animated: Bool)
    func viewDidAppear(animated: Bool)
    func numberOfEntities() -> Int
    func entityAt(index: IndexPath)-> Any?
    func getData(offset: Int) -> Void
}

protocol DialogsListInteractorInput: class {
    func getData(count: Int, offset: Int)
}

protocol DialogsListInteractorOutput: class {
    func success()
    func failure(error: Int)
}

protocol DialogsListRouterInterface: class {
    func showChat( dialog: Dialog)
    func setUpModule(fromViewController controller: UIViewController)
    func setUpModule()-> UIViewController
}
