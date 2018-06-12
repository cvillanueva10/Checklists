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
        navigationController?.popViewController(animated: true)
    }


    private let cellId = "cellId"

    var items: [ChecklistItem] = [
        ChecklistItem(text: "First label", checked: true),
        ChecklistItem(text: "Second label", checked: true),
        ChecklistItem(text: "Third label", checked: false),
        ChecklistItem(text: "Fourth label", checked: true),
        ChecklistItem(text: "Fifth label", checked: false),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Checklists"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddChecklistItem))
    }

    @objc func handleAddChecklistItem() {
//        let newRowIndex = items.count
//        let text = "Im a new label named: \(newRowIndex)"
//        let item = ChecklistItem(text: text, checked: false)
//        items.append(item)
//        let indexPath = IndexPath(row: newRowIndex, section: 0)
//        let indexPaths = [indexPath]
//        tableView.insertRows(at: indexPaths, with: .automatic)
        let addChecklistItemController = AddChecklistItemController()
        addChecklistItemController.delegate = self
        navigationController?.pushViewController(addChecklistItemController, animated: true)
    }

    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        if item.checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }

    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        cell.textLabel?.text = item.text
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let item = items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }



}

