//
//  ChecklistTableViewCell.swift
//  Checklists
//
//  Created by Chris Villanueva on 6/12/18.
//  Copyright © 2018 Christopher Villanueva. All rights reserved.
//

import UIKit

class ChecklistTableViewCell: UITableViewCell {
    
    let checkmarkLabel: UILabel = {
        let label = UILabel()
        label.text = "√"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setupView() {
        addSubview(checkmarkLabel)
        checkmarkLabel.frame = CGRect(
            origin:  CGPoint(x: 10, y: 0),
            size: CGSize(width: 30, height: frame.height)
        )
        addSubview(nameTextLabel)
        nameTextLabel.frame = CGRect(x: 40, y: 0, width: frame.width - 50, height: frame.height)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
