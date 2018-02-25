//
//  ChatTableViewCell.swift
//  VkMessenger
//
//  Created by Александр Чернов on 08.02.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell
{

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
    }

    func configureRightBubble ( model: Chat)
    {
       messageLabel.text = model.body
    }
    
}
