//
//  DialogsListInteractor.swift
//  VkMessenger
//
//  Created by Александр Чернов on 04.02.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import Foundation

class DialogsListInteractor: DialogsListInteractorInput {

    
    
    weak var output: DialogsListInteractorOutput?
    func getData(count: Int, offset: Int) {
        DialogManager.getDialog(count: count, offset: offset, success: {
            self.output?.success()
        }) { (error) in
            self.output?.failure(error: error)
        }
    }
    
    
}

