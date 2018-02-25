//
//  ChatInterfaces.swift
//  VkMessenger
//
//  Created by Александр Чернов on 08.02.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import Foundation
import UIKit

protocol ChatViewInterface: class {
    func reloadData()
    func scroll(index: Int)
    func handleInternetError(error: String)
}

protocol ChatFrcChangeViewInterface: class {
    func beginUpdates () -> Void
    func endUpdates () -> Void
    func insert ( at : IndexPath? ) -> Void
    func delete ( at : IndexPath ) -> Void
    func move ( from : IndexPath , to : IndexPath ) -> Void
    func update ( at : IndexPath ) -> Void
}

protocol ChatPresenterInterface: class {
    func getData()
    func viewWillAppear(animated: Bool)
    func viewDidAppear(animated: Bool)
    func numberOfEntities() -> Int
    func entityAt(index: IndexPath)-> Any?
    func sendMessage ( message: String )-> Void
}



protocol ChatInteractorInput: class {
    func getData( offset: Int, count: Int, peer_id: Int64)
    func sendMessage( peer_id: Int64, random_id: Int, message: String)
}

protocol ChatInteractorOutput: class {
    func success()
    func failure(error: Int)
    func sendMessageSuccess() -> Void
}

protocol ChatRouterInterface: class {
    func setUpModule(fromViewController controller: UIViewController)
    func setUpModule( dialog: Dialog ) -> UIViewController
}
