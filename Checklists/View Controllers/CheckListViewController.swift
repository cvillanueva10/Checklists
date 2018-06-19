//
//  ViewController.swift
//  Checklists
//
//  Created by Christopher Villanueva on 6/11/18.
//  Copyright © 2018 Christopher Villanueva. All rights reserved.
//

import UIKit

class CheckListViewController: UITableViewController, AddEditItemControllerDelegate {

    // MARK : - AddChecklistItem Protocol Stubs

    func addEditItemControllerDidCancel(_ controller: AddEditItemController) {
        navigationController?.popViewController(animated: true)
    }

    func addEditItemController(_ controller: AddEditItemController, didFinishEditing item: ChecklistItem) {

        if let index = checklist?.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            guard let cell = tableView.cellForRow(at: indexPath) as? ChecklistTableViewCell else { return }
            configureText(for: cell, with: item)
        }
        navigationController?.popViewController(animated: true)
    }

    func addEditItemController(_ controller: AddEditItemController, didFinishAdding item: ChecklistItem) {
        if let newRowIndex = checklist?.items.count {
            checklist?.items.append(item)
            let indexPath = IndexPath(row: newRowIndex, section: 0)
            let indexPaths = [indexPath]
            tableView.insertRows(at: indexPaths, with: .automatic)
            navigationController?.popViewController(animated: true)
        }
    }

    // MARK: - Properties

    private let cellId = "cellId"
    private let checklistCellId = "checklistCellId"
    var items = [ChecklistItem]()
    var checklist: Checklist?


    // MARK: - life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItems()
        tableView.separatorInset = .zero
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.register(ChecklistTableViewCell.self, forCellReuseIdentifier: checklistCellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    func configureNavigationItems() {
        if let checklist = checklist {
            navigationItem.title = checklist.name
        }
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddChecklistItem))
    }

    // MARK: - handlers

    @objc func handleAddChecklistItem() {
        let addEditItemController = AddEditItemController()
        addEditItemController.delegate = self
        navigationController?.pushViewController(addEditItemController, animated: true)
    }

    func handleEditChecklistItem(item: ChecklistItem) {
        let addEditItemController = AddEditItemController()
        addEditItemController.itemToEdit = item
        addEditItemController.delegate = self
        navigationController?.pushViewController(addEditItemController, animated: true)
    }

    // MARK: - Configure views

    private func configureCheckmark(for cell: ChecklistTableViewCell, with item: ChecklistItem) {
        cell.checkmarkLabel.text = item.checked ? "√" : ""
    }

    private func configureText(for cell: ChecklistTableViewCell, with item: ChecklistItem) {
        cell.nameTextLabel.text = item.text
    }

    // MARK: - Table view functions

    // Override this due to bug with CheckListTableViewCell
    // constraints
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    // Delete row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        checklist?.items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }

    // Edit row
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        guard let item = checklist?.items[indexPath.row] else { return }
        handleEditChecklistItem(item: item)
    }

    // Select row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ChecklistTableViewCell else { return }
        guard let item = checklist?.items[indexPath.row] else { return }
        item.toggleChecked()
        configureCheckmark(for: cell, with: item)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist?.items.count ?? 0
    }

    // Cell for rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: checklistCellId, for: indexPath) as! ChecklistTableViewCell
        cell.accessoryType = .detailDisclosureButton
        if let item = checklist?.items[indexPath.row] {
            configureText(for: cell, with: item)
            configureCheckmark(for: cell, with: item)
        }
        return cell
    }
}

