//
//  DialogsListViewController.swift
//  VkMessenger
//
//  Created by Александр Чернов on 04.02.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//


import UIKit

class DialogsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: DialogsListPresenter?
    var router: DialogsListRouter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        registrate()
        presenter?.viewDidLoad()
        tableView.reloadData()
    }
}

extension DialogsListViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return presenter?.numberOfEntities() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kDialogListCellReuseIdentifier", for: indexPath) as! DialogViewCell
        cell.configureSelf(modelDialog: presenter?.entityAt(index: indexPath) as! Dialog)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.showChat(id: (presenter?.entityAt(index: indexPath) as! Dialog).id)
    }
}


extension DialogsListViewController: DialogsListViewInterface

{
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func handleInternetError(error: String)
    {
    }
}

extension DialogsListViewController
{
    func registrate()
    {
        let nib = UINib(nibName: "DialogViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "kDialogListCellReuseIdentifier")
    }
}
