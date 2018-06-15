//
//  Checklist.swift
//  Checklists
//
//  Created by Christopher Villanueva on 6/12/18.
//  Copyright © 2018 Christopher Villanueva. All rights reserved.
//

import Foundation
import UIKit

class Checklist: NSObject, Codable {

    var name: String
    var iconName: String = "No Icon"
    var items: [ChecklistItem] = []
    
    // MARK: - lifecycle

    init(name: String, iconName: String = "No Icon"){
        self.name = name
        self.iconName = iconName
        super.init()
    }

    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
}




