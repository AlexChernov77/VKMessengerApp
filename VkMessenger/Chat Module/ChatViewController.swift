//
//  ChatViewController.swift
//  VkMessenger
//
//  Created by Александр Чернов on 08.02.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController
{
    let kRightBubbleCellNib = UINib(nibName: "ChatTableViewCell", bundle: nil)
    let kRightBubbleCellReuseIdentifier = "kRightBubbleCellReuseIdentifier"
    let kLeftBubbleCellNib = UINib(nibName: "ChatLeftTableViewCell", bundle: nil)
    let kLeftBubbleCellReuseIdentifier = "kLeftBubbleCellReuseIdentifier"
    var presenter: ChatPresenter?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.dataSource = self
            registrate()
            presenter?.getData()
    }
}

extension ChatViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         return presenter?.numberOfEntities() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = presenter?.entityAt(index: indexPath) as! ChatModel
        
        if model.out == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:kRightBubbleCellReuseIdentifier , for: indexPath) as! ChatTableViewCell
            
            print(model.body)
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

extension ChatViewController: ChatViewInterface
{
    func reloadData()
    {
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row:((presenter?.numberOfEntities())! - 1), section : 0), at: UITableViewScrollPosition.bottom, animated: false)
    }
    
    func handleInternetError(error: String)
    {
        
    }
}

extension ChatViewController
{
    func registrate()
    {
        self.tableView.register(kRightBubbleCellNib, forCellReuseIdentifier: kRightBubbleCellReuseIdentifier)

        self.tableView.register(kLeftBubbleCellNib, forCellReuseIdentifier: kLeftBubbleCellReuseIdentifier)
    }
}
