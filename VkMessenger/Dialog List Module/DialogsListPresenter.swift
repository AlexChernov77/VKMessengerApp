//
//  DialogsListPresenter.swift
//  VkMessenger
//
//  Created by Александр Чернов on 04.02.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import Foundation
import CoreData

class DialogsListPresenter: NSObject, DialogsListPresenterInterface
{

    weak var view: DialogsListViewInterface?
    weak var viewFrc: DialogsListFrcViewChange?
    var interactor: DialogsListInteractorInput?
    
    lazy var fetchedResultController : NSFetchedResultsController<NSFetchRequestResult> = {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Dialog")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.getMainContext(), sectionNameKeyPath: nil, cacheName: nil)
        
        
        _ = try? frc.performFetch()
        
        
        return frc
    }()
    // getData reName
    @objc func viewDidLoad()
    {
        fetchedResultController.delegate = self
        getData(offset: 0)
    }
    
    func viewWillAppear(animated: Bool)
    {
        
    }
    
    func viewDidAppear(animated: Bool)
    {
        
    }
    
    func getData(offset: Int) {
        interactor?.getData(count: 40, offset: offset)
    }
    
    func numberOfEntities() -> Int
    {
        if let objectsArray = fetchedResultController.fetchedObjects
        {
            return objectsArray.count
        }
        
        return 0
    }
    
    func entityAt(index: IndexPath) -> Any?
    {
        return fetchedResultController.object(at: index)
    }
}

extension DialogsListPresenter: DialogsListInteractorOutput
{
    func failure(error: Int)
    {
        print(error)
        self.view?.reloadData()
    }
    
    func success()
    {
        CoreDataManager.sharedInstance.save()
        self.view?.reloadData()
    }

}

//MARK:- протокол FetchedResultsControllerDelegate
extension DialogsListPresenter : NSFetchedResultsControllerDelegate
{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        viewFrc?.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        if type == .insert
        {
            viewFrc?.insert(at: newIndexPath!)
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
            viewFrc?.delete(at: indexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        viewFrc?.endUpdates()
    }
}
