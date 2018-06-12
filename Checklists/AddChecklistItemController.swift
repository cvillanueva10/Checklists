//
//  AddChecklistItemController.swift
//  Checklists
//
//  Created by Christopher Villanueva on 6/11/18.
//  Copyright © 2018 Christopher Villanueva. All rights reserved.
//

import UIKit

protocol AddChecklistItemControllerDelegate: class {
    func addChecklistItemControllerDidCancel(_ controller: AddChecklistItemController)
    func addChecklistItemController(_ controller: AddChecklistItemController, didFinishAdding item: ChecklistItem)
}

class AddChecklistItemController: UITableViewController, UITextFieldDelegate {

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

    weak var delegate: AddChecklistItemControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Adding"
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleSaveNewItem))
        doneButton?.isEnabled = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss))
        navigationItem.rightBarButtonItem = doneButton
        tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: staticNameField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    // Handles empty strings
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = nameTextField.text else { return false }
        guard let stringRange = Range(range, in: oldText) else { return false }
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneButton?.isEnabled = !newText.isEmpty
        return true
    }

    func configureTextField(for cell: UITableViewCell, at indexPath: IndexPath) {
        cell.addSubview(nameTextField)
        nameTextField.frame = CGRect(x: 10, y: 0, width: cell.frame.width - 20, height: cell.frame.height)
        nameTextField.delegate = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        if index == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: staticNameField, for: indexPath)
            configureTextField(for: cell, at: indexPath)
            return cell
        } else {
            return UITableViewCell()
        }
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }

    @objc func handleSaveNewItem() {
       // navigationController?.popViewController(animated: true)
        guard let nameText = nameTextField.text else { return }
        let newItem = ChecklistItem(text: nameText, checked: false)
        delegate?.addChecklistItemController(self, didFinishAdding: newItem)
        print("\(nameTextField.text ?? "")")
    }

    @objc func handleDismiss() {
        //navigationController?.popViewController(animated: true)
        delegate?.addChecklistItemControllerDidCancel(self)
    }

}
