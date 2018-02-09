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
    func handleInternetError(error: String)
}

protocol ChatPresenterInterface: class {
    func getData()
    func viewWillAppear(animated: Bool)
    func viewDidAppear(animated: Bool)
    func numberOfEntities() -> Int
    func entityAt(index: IndexPath)-> Any?
}

protocol ChatInteractorInput: class {
    func getData( offset: Int, count: Int, peer_id: Int64)
}

protocol ChatInteractorOutput: class {
    func success(array: NSArray)
    func failure(error: Int)
}

protocol ChatRouterInterface: class {
    func setUpModule(fromViewController controller: UIViewController)
    func setUpModule( id: Int64 ) -> UIViewController
}
