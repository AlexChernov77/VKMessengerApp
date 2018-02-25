//
//  ChatPresenter.swift
//  VkMessenger
//
//  Created by Александр Чернов on 07.02.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import Foundation
import CoreData

class ChatPresenter: NSObject, ChatPresenterInterface
{
    
    weak var view: ChatViewInterface?
    weak var viewFrc: ChatFrcChangeViewInterface?
    var interactor: ChatInteractorInput?
    var dialogIsEmpty = true
    var dialog: Dialog?
    var peer_id: Int64?
    
    var fetchedResultController : NSFetchedResultsController<NSFetchRequestResult>?

    init( dialog: Dialog)
    {
        self.dialog = dialog
        self.peer_id = dialog.id
        if dialog.title != ""
        {
            peer_id = 2000000000 + peer_id!
        }
    }
    
    func setUpFRC()
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
        let predicate = NSPredicate(format: "dialogs.id=%lld", (dialog?.id)! )
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.getMainContext(), sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        _ = try? frc.performFetch()
        fetchedResultController = frc
    }
    
    
    func getData()
    {
        interactor?.getData(offset: 0, count: 100, peer_id: peer_id!)
    }
    
    func viewWillAppear(animated: Bool)
    {
        if SingleChatFabric.hasMessages(id: peer_id!, context: CoreDataManager.sharedInstance.getMainContext())
        {
            print("есть сообщения")
            dialogIsEmpty = false
            setUpFRC()
            view?.reloadData()
            view?.scroll(index: (self.fetchedResultController?.fetchedObjects?.count ?? 1) - 1)
        }
        
        
        getData()
    }
    
    func viewDidAppear(animated: Bool)
    {

    }
    
    
    func sendMessage(message: String)
    {
        interactor?.sendMessage(peer_id: peer_id!, random_id: Int(arc4random()), message: message)
    }
    
    func numberOfEntities() -> Int
    {
        if fetchedResultController == nil
        {
            return 0
        }
        else
        {
            return fetchedResultController!.fetchedObjects!.count
        }
    }
    
    func entityAt(index: IndexPath) -> Any?
    {
        if fetchedResultController == nil
        {
            return nil
        }
        else
        {
            return fetchedResultController!.object(at:index)
        }
    }
}

extension ChatPresenter: ChatInteractorOutput
{
    func sendMessageSuccess()
    {
        view?.reloadData()
        view?.scroll(index: (self.fetchedResultController?.fetchedObjects?.count ?? 1) - 1)
    }
    
    func success()
    {
        if dialogIsEmpty
        {
            print("Пустой")
            setUpFRC()
            view?.reloadData()
            view?.scroll(index: (self.fetchedResultController?.fetchedObjects?.count ?? 1) - 1)
            dialogIsEmpty = false
        }
    }
    
    func failure(error: Int)
    {
        print(error)
    }
}

extension ChatPresenter : NSFetchedResultsControllerDelegate
{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
           self.viewFrc?.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        if type == .insert
        {
            viewFrc?.insert(at: newIndexPath!)
            view?.scroll(index: (self.fetchedResultController?.fetchedObjects?.count ?? 1) - 1)
        }
        
        if type == .update
        {
            viewFrc?.update(at: indexPath!)
        }
        
        if type == .move
        {
            viewFrc?.move(from: indexPath!, to: newIndexPath!)
        }
        
        if type == .delete
        {
            self.viewFrc?.delete(at: indexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        viewFrc?.endUpdates()
    }
}


