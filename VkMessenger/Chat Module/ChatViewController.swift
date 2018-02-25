//
//  ChatViewController.swift
//  VkMessenger
//
//  Created by Александр Чернов on 08.02.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import UIKit
import SDWebImage

class ChatViewController: UIViewController
{
    let kRightBubbleCellNib = UINib(nibName: "ChatTableViewCell", bundle: nil)
    let kRightBubbleCellReuseIdentifier = "kRightBubbleCellReuseIdentifier"
    let kLeftBubbleCellNib = UINib(nibName: "ChatLeftTableViewCell", bundle: nil)
    let kLeftBubbleCellReuseIdentifier = "kLeftBubbleCellReuseIdentifier"
    var presenter: ChatPresenter?

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        moveKeyBoard()
        setNavItem()
        registrate()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
            super.viewWillAppear(animated)
            self.presenter?.viewWillAppear(animated: animated)
    }
}

extension ChatViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         return presenter?.numberOfEntities() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = presenter?.entityAt(index: indexPath) as! Chat
        
        if model.out == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:kRightBubbleCellReuseIdentifier , for: indexPath) as! ChatTableViewCell
            
            
            cell.configureRightBubble(model: model)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:kLeftBubbleCellReuseIdentifier , for: indexPath) as! ChatLeftTableViewCell

            cell.configureLeftBubble(model: model)
            return cell
        }
    }
}

extension ChatViewController: UITextFieldDelegate
{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func sendMessage(_ sender: Any) {
       if textField.text != ""
       {
        presenter?.sendMessage(message: textField.text!)
       }
        textField.text = ""
    }
    
}

extension ChatViewController: ChatViewInterface
{
    func scroll(index: Int)
    {
        DispatchQueue.main.async
        {
                self.tableView.scrollToRow(at: IndexPath(row: index, section : 0), at: UITableViewScrollPosition.bottom, animated: false)
        }
    }
    
    func reloadData()
    {
        DispatchQueue.main.async
            {
            self.tableView.reloadData()
            }
    }
    
    func handleInternetError(error: String)
    {
        
    }
}


extension ChatViewController: ChatFrcChangeViewInterface
{
    func beginUpdates()
    {
        self.tableView.beginUpdates()
    }
    
    func insert(at: IndexPath?)
    {
        if let indexPath = at
        {
        self.tableView.insertRows(at: [indexPath], with: .fade)
        }
    }
    
    func delete(at: IndexPath)
    {
        self.tableView.deleteRows(at: [at], with: .fade)
    }
    
    func move(from: IndexPath, to: IndexPath)
    {
        let indexPath = from
            tableView.deleteRows(at: [indexPath], with: .fade)

        let newIndexPath = to
            tableView.insertRows(at: [newIndexPath], with: .fade)

    }
    
    func update(at: IndexPath)
    {
        self.tableView.reloadRows(at: [at], with: .fade)
    }
    
    func endUpdates()
    {
        self.tableView.endUpdates()
    }
}

extension ChatViewController
{
    func registrate()
    {
        
        self.textField.delegate = self
        
        self.tableView.register(kRightBubbleCellNib, forCellReuseIdentifier: kRightBubbleCellReuseIdentifier)

        self.tableView.register(kLeftBubbleCellNib, forCellReuseIdentifier: kLeftBubbleCellReuseIdentifier)
    }
}

extension ChatViewController
{
    func moveKeyBoard()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @objc func keyboardWillShow (notification: NSNotification)
    {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil
        {
           self.view.frame.origin.y = 0
           self.view.frame.origin.y -= 253
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil
        {
            self.view.frame.origin.y = 0
        }
    }
}


extension ChatViewController
{
    func setNavItem ()
    {
        navigationItem.title = presenter?.dialog?.title == "" ? (presenter?.dialog?.users?.allObjects as! [User])[0].name : presenter?.dialog?.title
        
        let imageView = UIImageView()
        
        if presenter?.dialog?.title == ""
        {
            imageView.sd_setImage(with: URL(string: (presenter?.dialog?.users?.allObjects as! [User])[0].miniAvatarURL!))
        }
        else
        {
            imageView.sd_setImage(with: URL(string: (presenter?.dialog?.miniAvatar!)!))
        }

        imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 23
        imageView.clipsToBounds = true
        
        let barButtonItem = UIBarButtonItem(customView: imageView)
        navigationItem.rightBarButtonItem = barButtonItem
    }
}



