//
//  ViewController.swift
//  Checklists
//
//  Created by Christopher Villanueva on 6/11/18.
//  Copyright © 2018 Christopher Villanueva. All rights reserved.
//

import UIKit

class CheckListViewController: UITableViewController, AddChecklistItemControllerDelegate {

    // MARK : - AddChecklistItem Protocol Stubs

    func addChecklistItemControllerDidCancel(_ controller: AddChecklistItemController) {
        navigationController?.popViewController(animated: true)
    }

    func addChecklistItemController(_ controller: AddChecklistItemController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = items.count
        items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }

    private let cellId = "cellId"
    private let checklistCellId = "checklistCellId"

    var items: [ChecklistItem] = [
        ChecklistItem(text: "Wash dishes", checked: false),
        ChecklistItem(text: "Vacuum", checked: true),
        ChecklistItem(text: "Iron clothes", checked: false)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(ChecklistTableViewCell.self, forCellReuseIdentifier: checklistCellId)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Checklists"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddChecklistItem))
    }

    @objc func handleAddChecklistItem() {
        let addChecklistItemController = AddChecklistItemController()
        addChecklistItemController.delegate = self
        navigationController?.pushViewController(addChecklistItemController, animated: true)
    }

    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
//        if item.checked {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
    }

    func configureText(for cell: ChecklistTableViewCell, with item: ChecklistItem) {
        //cell.textLabel?.text = item.text
        cell.nameTextLabel.text = item.text
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let item = items[indexPath.row]
        item.toggleChecked()
        configureCheckmark(for: cell, with: item)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: checklistCellId, for: indexPath) as! ChecklistTableViewCell
         cell.accessoryType = .detailDisclosureButton
        let item = items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }



}

