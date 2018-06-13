//
//  AddEditListController.swift
//  Checklists
//
//  Created by Christopher Villanueva on 6/12/18.
//  Copyright © 2018 Christopher Villanueva. All rights reserved.
//

import UIKit

protocol AddEditListControllerDelegate : class {
    func addEditListControllerDidCancel(_ controller: AddEditListController)
    func addEditListController(_ controller: AddEditListController, didFinishAdding list: Checklist)
    func addEditListController(_ controller: AddEditListController, didFinishEditing list: Checklist)
}

class AddEditListController: UITableViewController, UITextFieldDelegate {

    private let staticNameField = "staticNameField"

    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.adjustsFontSizeToFitWidth = false
        textField.autocapitalizationType = .sentences
        textField.enablesReturnKeyAutomatically = true
        textField.returnKeyType = .done
        textField.placeholder = "Name"
        textField.borderStyle = .none
        textField.becomeFirstResponder()
        return textField
    }()

    var doneButton: UIBarButtonItem?
    var checklistToEdit: Checklist?
    weak var delegate: AddEditListControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: staticNameField)
        configureNavigiationItems()
    }

    // TODO: - Refactor this into helpful extension
    func configureTextField(for cell: UITableViewCell, at indexPath: IndexPath) {
        cell.addSubview(nameTextField)
        nameTextField.frame = CGRect(x: 10, y: 0, width: cell.frame.width - 20, height: cell.frame.height)
        nameTextField.delegate = self
    }

    func configureNavigiationItems() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss))
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleSaveNewList))
        navigationItem.rightBarButtonItem = doneButton
        if let checklistToEdit = checklistToEdit {
            navigationItem.title = "Edit Checklist"
            nameTextField.text = checklistToEdit.name
            doneButton?.isEnabled = true
        } else {
            navigationItem.title = "Add Checklist"
            doneButton?.isEnabled = false
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: staticNameField, for: indexPath)
        configureTextField(for: cell, at: indexPath)
        return cell
    }

    // TODO: - Add saving list functionality
    @objc func handleSaveNewList(){
        delegate?.addEditListControllerDidCancel(self)
    }

    @objc func handleDismiss() {
        delegate?.addEditListControllerDidCancel(self)
    }

}
