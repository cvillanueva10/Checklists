//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by Chris Villanueva on 6/14/18.
//  Copyright © 2018 Christopher Villanueva. All rights reserved.
//

import UIKit

enum Icon: String {
    case none = "No Icon"
    case appointments = "Appointments"
    case birthdays = "Birthdays"
    case chores = "Chores"
    case drinks = "Drinks"
    case folder = "Folder"
    case groceries = "Groceries"
    case inbox = "Inbox"
    case photos = "Photos"
    case trips = "Trips"
}

protocol IconPickerViewControllerDelegate: class {
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String)
}

class IconPickerViewController: UITableViewController {

    // MARK: - properties
    private let IconCell = "IconCell"
    weak var delegate: IconPickerViewControllerDelegate?

    var icons = [Icon.none, Icon.appointments, Icon.birthdays, Icon.chores, Icon.drinks, Icon.folder, Icon.groceries, Icon.inbox, Icon.photos, Icon.trips ]

    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Choose Icon"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: IconCell)
    }

    // MARK: - table view delegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let iconName = icons[indexPath.row].rawValue
        delegate?.iconPicker(self, didPick: iconName)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IconCell, for: indexPath)
        let iconName = icons[indexPath.row].rawValue
        cell.textLabel?.text = iconName
        cell.imageView?.image = UIImage(named: iconName)
        return cell
    }
}
