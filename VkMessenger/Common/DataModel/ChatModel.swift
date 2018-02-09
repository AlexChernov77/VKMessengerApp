//
//  ChatModel.swift
//  VkMessenger
//
//  Created by Александр Чернов on 09.02.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import Foundation
class ChatModel
{
    var id: Int64
    var body: String
    var date: Int64
    var out: Int64
    var read_state: Int64
    
    init(id: Int64, date: Int64, body: String, out: Int64, read_state: Int64)
    {
        self.body = body
        self.id = id
        self.date = date
        self.out = out
        self.read_state = read_state
    }
}
