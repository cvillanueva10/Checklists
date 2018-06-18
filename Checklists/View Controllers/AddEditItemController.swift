//
//  AddChecklistItemController.swift
//  Checklists
//
//  Created by Christopher Villanueva on 6/11/18.
//  Copyright © 2018 Christopher Villanueva. All rights reserved.
//

import UIKit
import UserNotifications

protocol AddEditItemControllerDelegate: class {
    func addEditItemControllerDidCancel(_ controller: AddEditItemController)
    func addEditItemController(_ controller: AddEditItemController, didFinishAdding item: ChecklistItem)
    func addEditItemController(_ controller: AddEditItemController, didFinishEditing item: ChecklistItem)
}

class AddEditItemController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - properties
    
    private let cellIdentifier = "cellIdentifier"
    private let detailedIndentifier = "detailedIdentifier"
    private let datePickerIdentifier = "datePickerIdentifier"
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.adjustsFontSizeToFitWidth = false
        textField.autocapitalizationType = .sentences
        textField.enablesReturnKeyAutomatically = true
        textField.returnKeyType = .done
        textField.placeholder = "Name of the item"
        textField.borderStyle = .none
        textField.becomeFirstResponder()
        return textField
    }()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return picker
    }()
    
    lazy var shouldRemindSwitch: UISwitch = {
        let remindSwitch = UISwitch()
        remindSwitch.isOn = false
        remindSwitch.addTarget(self, action: #selector(requestAuth), for: .valueChanged)
        remindSwitch.translatesAutoresizingMaskIntoConstraints = false
        return remindSwitch
    }()
    
    var doneButton: UIBarButtonItem?
    weak var delegate: AddEditItemControllerDelegate?
    var itemToEdit: ChecklistItem?
    var dueDate = Date()
    var dueDateLabel = UILabel()
    var datePickerIsVisible = false
    
    // MARK: - lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItems()
        updateDueDateLabel()
        tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.separatorInset = .zero
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.register(DetailedTableViewCell.self, forCellReuseIdentifier: detailedIndentifier)
    }
    
    func configureNavigationItems() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss))
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleSaveNewItem))
        navigationItem.rightBarButtonItem = doneButton
        if let itemToEdit = itemToEdit {
            navigationItem.title = "Edit Item"
            nameTextField.text = itemToEdit.text
            doneButton?.isEnabled = true
            shouldRemindSwitch.isOn = itemToEdit.shouldRemind
            dueDate = itemToEdit.dueDate
        } else {
            navigationItem.title = "Add Item"
            doneButton?.isEnabled = false
        }
    }
    
    @objc func requestAuth() {
        if shouldRemindSwitch.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                print("Granted")
            }
        }
    }
    
    // MARK: - update UI methods

    // FIXME: - fix detail text color
    
    func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate)
        let indexPathDateRow = IndexPath(row: 1, section: 1)

        tableView.reloadRows(at: [indexPathDateRow], with: .none)
    }
    
    func hideDatePicker() {
        if datePickerIsVisible {
            datePickerIsVisible = false
            let indexPathDatePicker = IndexPath(row: 2, section: 1)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func showDatePicker() {
        datePickerIsVisible = true
        //let indexPathDateRow = IndexPath(row: 1, section: 1)
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        
        // FIXME: - invstigate UI bug with table view cells
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        self.tableView.endUpdates()
        datePicker.setDate(dueDate, animated: false)
    }
    
    @objc func dateChanged() {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    
    // MARK: - textfield delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
    
    // Handles empty strings
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = nameTextField.text else { return false }
        guard let stringRange = Range(range, in: oldText) else { return false }
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneButton?.isEnabled = !newText.isEmpty
        return true
    }
    
    // MARK: - cell UI configurations
    
    private func configureTextField(for cell: UITableViewCell, at indexPath: IndexPath) {
        cell.addSubview(nameTextField)
        nameTextField.frame = CGRect(x: 10, y: 0, width: cell.frame.width - 20, height: cell.frame.height)
        nameTextField.delegate = self
    }
    
    private func configureReminderSwitch(for cell: UITableViewCell) {
        cell.textLabel?.text = "Remind Me"
        cell.addSubview(shouldRemindSwitch)
        shouldRemindSwitch.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -15).isActive = true
        shouldRemindSwitch.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
    }
    
    private func configureDateField(for cell: DetailedTableViewCell) {
        cell.textLabel?.text = "Due Date"
        cell.detailTextLabel?.text = dueDateLabel.text
    }
    
    // MARK: - table view delegates
        
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            if datePickerIsVisible {
                return 3
            } else {
                return 2
            }
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        nameTextField.resignFirstResponder()
        if indexPath.section == 1 && indexPath.row == 1 {
            if datePickerIsVisible {
                hideDatePicker()
            } else {
                showDatePicker()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        if section == 0 && row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            configureTextField(for: cell, at: indexPath)
            return cell
        } else if section == 1{
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
                configureReminderSwitch(for: cell)
                return cell
            } else if row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: detailedIndentifier, for: indexPath) as! DetailedTableViewCell
                configureDateField(for: cell)
                return cell
            } else if row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
                cell.heightAnchor.constraint(equalToConstant: 217).isActive = true
                cell.addSubview(datePicker)
                datePicker.frame = cell.frame
                return cell
            }
        }
        return UITableViewCell()
    }
   
    // MARK: - handlers
    
    @objc func handleSaveNewItem() {
        guard let nameText = nameTextField.text else { return }
        if let itemToEdit = itemToEdit {
            itemToEdit.text = nameText
            itemToEdit.shouldRemind = shouldRemindSwitch.isOn
            itemToEdit.dueDate = dueDate
            itemToEdit.scheduleNotification()
            delegate?.addEditItemController(self, didFinishEditing: itemToEdit)
        } else {
            let newItem = ChecklistItem(text: nameText, checked: false)
            newItem.shouldRemind = shouldRemindSwitch.isOn
            newItem.dueDate = dueDate
            newItem.scheduleNotification()
            delegate?.addEditItemController(self, didFinishAdding: newItem)
        }
    }
    
    @objc func handleDismiss() {
        delegate?.addEditItemControllerDidCancel(self)
    }
    
}
