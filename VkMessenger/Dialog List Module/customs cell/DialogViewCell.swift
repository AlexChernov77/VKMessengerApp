//
//  DialogViewCell.swift
//  VkMessenger
//
//  Created by Александр Чернов on 20.01.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import UIKit
import SDWebImage

class DialogViewCell: UITableViewCell {

    private let kCollectionViewCellXIBName = "AvatarCollectionVC"
    private let kCollectionViewCellReuseIdentifier = "kPostsCellIdentifier"
    
    @IBOutlet weak var contentViewCell: UIView!
    @IBOutlet weak var avatarCollectionView: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var dataSource = [Any]()
    var chat: Dialog?
    override func awakeFromNib() {
        super.awakeFromNib()

        
        avatarCollectionView.register( UINib(nibName: kCollectionViewCellXIBName, bundle: nil), forCellWithReuseIdentifier: kCollectionViewCellReuseIdentifier)
        avatarCollectionView.layer.cornerRadius = 45
        avatarCollectionView.clipsToBounds = true
        avatarCollectionView.dataSource = self
        avatarCollectionView.delegate = self

        
    }

    
    func configureSelf ( modelDialog: Dialog)
    {
        chat = modelDialog
        
        if modelDialog.multiChatPhotoURL == "empty"
        {
            dataSource = (modelDialog.users?.allObjects)!
        }
        else
        {
            dataSource = [modelDialog.multiChatPhotoURL!]
        }
        
        if modelDialog.title != ""
        {
            nameLabel.text = modelDialog.title
        }
        else
        {
            nameLabel.text = (dataSource as! [User])[0].name
        }
        
        
            
             bodyLabel.text = modelDialog.body
        
        
        if (modelDialog.unread == 0) && (modelDialog.out == 0)
        {
            contentViewCell.backgroundColor = UIColor.groupTableViewBackground
        }
        
        if (modelDialog.unread == 0) && (modelDialog.out == 1)
        {
            bodyLabel.backgroundColor = UIColor.groupTableViewBackground
        }
        dateLabel.text = DataTransformManager.dateTransform(date: modelDialog.date!)
        
        avatarCollectionView.reloadData()
        
        
    }
     
}


extension DialogViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCollectionViewCellReuseIdentifier, for: indexPath) as! AvatarCollectionVC
        
        if chat?.multiChatPhotoURL == "empty"
        {
            cell.configureViewPhoto(photoURL: (dataSource as! [User])[indexPath.item].avatarURL!)
        }
        else
        {
            cell.configureViewPhoto(photoURL: dataSource[0] as! String)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        if dataSource.count == 1 {
            return avatarCollectionView.frame.size
        }
        else if dataSource.count == 2
        {
            return CGSize(width: avatarCollectionView.frame.width/2, height: avatarCollectionView.frame.height)
        }
        else
        {
        return CGSize(width: avatarCollectionView.frame.width/2, height: avatarCollectionView.frame.height/2)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0.5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
}
