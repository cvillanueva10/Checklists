//
//  Checklist.swift
//  Checklists
//
//  Created by Christopher Villanueva on 6/12/18.
//  Copyright © 2018 Christopher Villanueva. All rights reserved.
//

import Foundation

class Checklist: NSObject, Codable {

    var name: String
    var items: [ChecklistItem] = []

    init(name: String){
        self.name = name
        super.init()
    }
}
