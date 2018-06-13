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
        saveChecklistItems()
    }

    func addEditItemController(_ controller: AddEditItemController, didFinishEditing item: ChecklistItem) {

        if let index = items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            guard let cell = tableView.cellForRow(at: indexPath) as? ChecklistTableViewCell else { return }
            configureText(for: cell, with: item)
        }
        navigationController?.popViewController(animated: true)
        saveChecklistItems()
    }

    func addEditItemController(_ controller: AddEditItemController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = items.count
        items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
        saveChecklistItems()
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
        loadChecklistItems()
        tableView.register(ChecklistTableViewCell.self, forCellReuseIdentifier: checklistCellId)
    }

    func configureNavigationItems() {
        if let checklist = checklist {
            navigationItem.title = checklist.name
        }
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddChecklistItem))
    }

    // MARK: - Data handling / saving methods

    func saveChecklistItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath(), options: .atomic)
        } catch {
            print("Error encoding item array")
        }
    }

    func loadChecklistItems() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([ChecklistItem].self, from: data)
            } catch {
                print("Error decoding item array")
            }
        }
    }

    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }

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

    func configureCheckmark(for cell: ChecklistTableViewCell, with item: ChecklistItem) {
        cell.checkmarkLabel.text = item.checked ? "√" : ""
    }

    func configureText(for cell: ChecklistTableViewCell, with item: ChecklistItem) {
        cell.nameTextLabel.text = item.text
    }

    // MARK: - Table view functions

    // Delete row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }

    // Edit row
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let item = items[indexPath.row]
        handleEditChecklistItem(item: item)
    }

    // Select row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ChecklistTableViewCell else { return }
        let item = items[indexPath.row]
        item.toggleChecked()
        configureCheckmark(for: cell, with: item)
        tableView.deselectRow(at: indexPath, animated: true)
        saveChecklistItems()
    }

    // Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    // Cell for rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: checklistCellId, for: indexPath) as! ChecklistTableViewCell
        cell.accessoryType = .detailDisclosureButton
        let item = items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
}

