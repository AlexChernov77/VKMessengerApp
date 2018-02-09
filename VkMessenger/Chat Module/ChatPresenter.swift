//
//  ChatPresenter.swift
//  VkMessenger
//
//  Created by Александр Чернов on 07.02.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import Foundation
import CoreData

class ChatPresenter: ChatPresenterInterface
{
    weak var view: ChatViewInterface?
    var peer_id: Int64?
    var dataSource = NSArray()
    var interactor: ChatInteractorInput?
    init(peer_id: Int64)
    {
        self.peer_id = peer_id
    }
    
    
    func getData()
    {
        if peer_id! < 5000
        {
            peer_id = 2000000000 + peer_id!
        interactor?.getData(offset: 0, count: 50, peer_id: self.peer_id!)
        }
        else
        {
        interactor?.getData(offset: 0, count: 50, peer_id: self.peer_id!)
        }
    }
    
    func viewWillAppear(animated: Bool)
    {
        
    }
    
    func viewDidAppear(animated: Bool)
    {

    }
    
    func numberOfEntities() -> Int
    {
        return dataSource.count
    }
    
    func entityAt(index: IndexPath) -> Any?
    {
        let index = (dataSource.count - 1) - index.row
        if dataSource.count - 1 < index
        {
            return nil
        }
        else
        {
            return dataSource[index]
        }
    }
}

extension ChatPresenter: ChatInteractorOutput
{
    func success(array: NSArray) {
        DispatchQueue.main.async {
            self.dataSource = array
            self.view?.reloadData()
        }
    }
    
    
    func failure(error: Int) {
        print(error)
    }
}



