//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Christopher Villanueva on 6/11/18.
//  Copyright © 2018 Christopher Villanueva. All rights reserved.
//

import Foundation


class ChecklistItem: NSObject, Codable {

    static func == (lhs: ChecklistItem, rhs: ChecklistItem) -> Bool {
        return lhs.text == rhs.text
    }

    var text: String
    var checked: Bool

    init(text: String, checked: Bool){
        self.text = text
        self.checked = checked
        super.init()
    }

    func toggleChecked() {
        checked = !checked
    }


}
