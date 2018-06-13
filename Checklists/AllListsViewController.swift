//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Christopher Villanueva on 6/12/18.
//  Copyright © 2018 Christopher Villanueva. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, AddEditListControllerDelegate {

    func addEditListControllerDidCancel(_ controller: AddEditListController) {
        navigationController?.popViewController(animated: true)
    }

    func addEditListController(_ controller: AddEditListController, didFinishAdding list: Checklist) {
         navigationController?.popViewController(animated: true)
    }

    func addEditListController(_ controller: AddEditListController, didFinishEditing list: Checklist) {
         navigationController?.popViewController(animated: true)
    }


    private let checklistCell = "checklistCell"
    var lists = [Checklist]()

    override func viewDidLoad() {
        super.viewDidLoad()

        lists = [
            Checklist(name: "Birthdays"),
            Checklist(name: "Groceries"),
            Checklist(name: "Cool Apps"),
            Checklist(name: "To Do")
        ]

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Checklists"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddChecklist))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: checklistCell)
    }

    @objc func handleAddChecklist() {
        let addEditListController = AddEditListController()
        addEditListController.delegate = self
        navigationController?.pushViewController(addEditListController, animated: true)
    }

    @objc func handleEditChecklist(list: Checklist) {
        let addEditListController = AddEditListController()
        addEditListController.checklistToEdit = list
        addEditListController.delegate = self
        navigationController?.pushViewController(addEditListController, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let checklistViewController = CheckListViewController()
        checklistViewController.checklist = lists[indexPath.row]
        navigationController?.pushViewController(checklistViewController, animated: true)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = lists[indexPath.row]
        handleEditChecklist(list: list)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: checklistCell, for: indexPath)
        let list = lists[indexPath.row]
        cell.textLabel?.text = list.name
        cell.accessoryType = .detailDisclosureButton
        return cell
    }

}
