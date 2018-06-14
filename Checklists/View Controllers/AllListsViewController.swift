//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Christopher Villanueva on 6/12/18.
//  Copyright © 2018 Christopher Villanueva. All rights reserved.
//

import UIKit

// MARK: - custom table view cell for subtitles

class SubtitleTableViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - main view controller

class AllListsViewController: UITableViewController, AddEditListControllerDelegate, UINavigationControllerDelegate {

    // MARK: - protocol stubs

    func addEditListControllerDidCancel(_ controller: AddEditListController) {
        navigationController?.popViewController(animated: true)
    }

    func addEditListController(_ controller: AddEditListController, didFinishAdding list: Checklist) {
        let newIndex = dataModel.lists.count
        dataModel.lists.append(list)
        let indexPath = IndexPath(row: newIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }

    func addEditListController(_ controller: AddEditListController, didFinishEditing list: Checklist) {
        guard let index = dataModel.lists.index(of: list) else { return }
        let indexPath = IndexPath(row: index, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.textLabel?.text = list.name
        navigationController?.popViewController(animated: true)
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }

    // MARK: - properties

    private let checklistCell = "checklistCell"
    var dataModel: DataModel!

    // MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Checklists"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddChecklist))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: checklistCell)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            let checklistViewController = CheckListViewController()
            checklistViewController.checklist = dataModel.lists[index]
            navigationController?.pushViewController(checklistViewController, animated: true)
        }
    }

    // MARK: - handlers

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

    // MARK: - table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let list = dataModel.lists[indexPath.row]
        handleEditChecklist(list: list)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklistViewController = CheckListViewController()
        checklistViewController.checklist = dataModel.lists[indexPath.row]
        navigationController?.pushViewController(checklistViewController, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: checklistCell, for: indexPath) as! SubtitleTableViewCell
        let list = dataModel.lists[indexPath.row]
        cell.textLabel?.text = list.name
        cell.detailTextLabel!.text = "\(list.countUncheckedItems()) Items Remaining"
        cell.accessoryType = .detailDisclosureButton
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
}
