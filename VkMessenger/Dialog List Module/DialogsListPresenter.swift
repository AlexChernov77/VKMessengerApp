//
//  DialogsListPresenter.swift
//  VkMessenger
//
//  Created by Александр Чернов on 04.02.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import Foundation
import CoreData

class DialogsListPresenter: NSObject, DialogsListPresenterInterface {
    
    weak var view: DialogsListViewInterface?
    var interactor: DialogsListInteractorInput?
    
    lazy var fetchedResultController : NSFetchedResultsController<NSFetchRequestResult> = {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Dialog")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.getMainContext(), sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        _ = try? frc.performFetch()
        
        
        return frc
    }()
    // getData reName
    func viewDidLoad() {
        interactor?.getData()
    }
    
    func viewWillAppear(animated: Bool) {
        
    }
    
    func viewDidAppear(animated: Bool) {
        
    }
    
    func numberOfEntities() -> Int {
        if let objectsArray = fetchedResultController.fetchedObjects
        {
            return objectsArray.count
        }
        
        return 0
    }
    
    func entityAt(index: IndexPath) -> Any? {
        return fetchedResultController.object(at: index)
    }
}

extension DialogsListPresenter: DialogsListInteractorOutput {
    func failure(error: Int) {
        print(error)
    }
    
    func success() {
        CoreDataManager.sharedInstance.save()
    }

}

//MARK:- протокол FetchedResultsControllerDelegate
extension DialogsListPresenter : NSFetchedResultsControllerDelegate
{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        view?.reloadData()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        
    }
}
