//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Christopher Villanueva on 6/11/18.
//  Copyright © 2018 Christopher Villanueva. All rights reserved.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, Codable {

    static func == (lhs: ChecklistItem, rhs: ChecklistItem) -> Bool {
        return lhs.text == rhs.text
    }

    var text: String
    var checked: Bool
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int

    init(text: String, checked: Bool){
        self.text = text
        self.checked = checked
        self.itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    deinit {
        removeNotification()
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    
    func scheduleNotification() {
        removeNotification()
        if shouldRemind && dueDate > Date() {
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default()
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request, withCompletionHandler: nil)
        }
    }

    func toggleChecked() {
        checked = !checked
    }


}
