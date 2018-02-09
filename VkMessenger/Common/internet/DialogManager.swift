//
//  DialogManager.swift
//  VkMessenger
//
//  Created by Александр Чернов on 19.01.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import Foundation

class DialogManager
{
    class func getDialog (count : Int, offset: Int, success : @escaping () -> Void, failure : @escaping (Int) -> Void)
    {
        let operation = GetDialogsOperation(success: success, failure: failure, count: count, offSet: offset)
        OperationManager.addOperation(op: operation, cancellingQueue: true)
    }
}
