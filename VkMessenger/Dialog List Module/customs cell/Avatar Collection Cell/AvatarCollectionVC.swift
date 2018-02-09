//
//  AvatarCollectionVC.swift
//  VkMessenger
//
//  Created by Александр Чернов on 20.01.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import UIKit

class AvatarCollectionVC: UICollectionViewCell
{
    
    
    @IBOutlet weak var ViewPhoto: UIImageView!
    
    func configureViewPhoto(photoURL:String)
    {
        ViewPhoto.sd_setImage(with: NSURL(string: photoURL) as URL?)
    }
    
}
