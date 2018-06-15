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

class AddEditListController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {

    // MARK: - protocol stubs

    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        setIcon(iconName: iconName)
        navigationController?.popViewController(animated: true)
    }

    // MARK: - properties
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

    var iconName: String = "None"

    lazy var iconImageView: UIImageView = {
        let image = UIImage(named: iconName)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    var doneButton: UIBarButtonItem?
    var checklistToEdit: Checklist?
    weak var delegate: AddEditListControllerDelegate?

    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.separatorInset = .zero
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: staticNameField)
        configureNavigiationItems()
    }

    // MARK: - setter

    func setIcon(iconName: String) {
        self.iconName = iconName
        self.iconImageView.image = UIImage(named: iconName)
    }

    // MARK: - data validation
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = nameTextField.text else { return false }
        guard let stringRange = Range(range, in: oldText) else { return false }
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneButton?.isEnabled = !newText.isEmpty
        return true
    }

    // TODO: - Refactor this into helpful extension
    // MARK: - configuration functions
    func configureTextField(for cell: UITableViewCell) {
        cell.addSubview(nameTextField)
        nameTextField.frame = CGRect(x: 10, y: 0, width: cell.frame.width - 20, height: cell.frame.height)
        nameTextField.delegate = self
    }

    func configureIconPickerField(for cell: UITableViewCell, at indexPath: IndexPath) {
        cell.textLabel?.text = "Icon"
        cell.accessoryType = .disclosureIndicator
        cell.addSubview(iconImageView)
        iconImageView.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -40).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }

    func configureNavigiationItems() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss))
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleSaveNewList))
        navigationItem.rightBarButtonItem = doneButton
        if let checklistToEdit = checklistToEdit {
            navigationItem.title = "Edit Checklist"
            nameTextField.text = checklistToEdit.name
            iconImageView.image = UIImage(named: checklistToEdit.iconName)
            doneButton?.isEnabled = true
        } else {
            navigationItem.title = "Add Checklist"
            doneButton?.isEnabled = false
        }
    }

    // MARK: - table view delegates

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let iconPickerViewController = IconPickerViewController()
            iconPickerViewController.delegate = self
            navigationController?.pushViewController(iconPickerViewController, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: staticNameField, for: indexPath)
        switch indexPath.section {
        case 0:
            configureTextField(for: cell)
        case 1:
            configureIconPickerField(for: cell, at: indexPath)
        default:
            break
        }

        return cell
    }

    @objc func handleSaveNewList(){
        guard let nameText = nameTextField.text else { return }
        if let checklistToEdit = checklistToEdit {
            checklistToEdit.name = nameText
            checklistToEdit.iconName = iconName
            delegate?.addEditListController(self, didFinishEditing: checklistToEdit)
        } else {
            let list = Checklist(name: nameText, iconName: iconName)
            delegate?.addEditListController(self, didFinishAdding: list)
        }
    }

    @objc func handleDismiss() {
        delegate?.addEditListControllerDidCancel(self)
    }

}
