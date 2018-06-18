//
//  DetailedTableViewCell.swift
//  Checklists
//
//  Created by Chris Villanueva on 6/18/18.
//  Copyright © 2018 Christopher Villanueva. All rights reserved.
//

import UIKit

class DetailedTableViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
