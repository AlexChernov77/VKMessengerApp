//
//  ChatLeftTableViewCell.swift
//  VkMessenger
//
//  Created by Александр Чернов on 09.02.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import UIKit

class ChatLeftTableViewCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
    }
    
    func configureLeftBubble ( model: Chat)
    {
        messageLabel.text = model.body
    }
    
}
