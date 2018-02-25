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
    let refreshController = UIRefreshControl()
    
    var presenter: DialogsListPresenter?
    var router: DialogsListRouter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        registrate()
        presenter?.viewDidLoad()
        refreshControl()
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
        router?.showChat(dialog: (presenter?.entityAt(index: indexPath) as! Dialog))
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (presenter?.numberOfEntities() ?? 0 ) - 15
        {
            presenter?.getData(offset: presenter?.numberOfEntities() ?? 0)
        }
    }
}


extension DialogsListViewController: DialogsListViewInterface

{
    
    func reloadData()
    {
        DispatchQueue.main.async
        {
            self.refreshController.endRefreshing()
            self.tableView.reloadData()
        }
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
    
    func refreshControl() {
        refreshController.attributedTitle = NSAttributedString(string: "Обновление")
        refreshController.addTarget(self, action: #selector(presenter?.viewDidLoad), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshController)
    }
}

extension DialogsListViewController: DialogsListFrcViewChange
{
    func beginUpdates()
    {
        self.tableView.beginUpdates()
    }
    
    func insert(at: IndexPath)
    {
        self.tableView.insertRows(at: [at], with: .fade)
    }
    
    func delete(at: IndexPath)
    {
        self.tableView.deleteRows(at: [at], with: .fade)
    }
    
    func move(from: IndexPath, to: IndexPath)
    {
         let indexPath = from

            tableView.deleteRows(at: [indexPath], with: .automatic)

        
         let newIndexPath = to
            tableView.insertRows(at: [newIndexPath], with: .automatic)

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
