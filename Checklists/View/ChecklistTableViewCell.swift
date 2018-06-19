//
//  ChecklistTableViewCell.swift
//  Checklists
//
//  Created by Chris Villanueva on 6/12/18.
//  Copyright © 2018 Christopher Villanueva. All rights reserved.
//

import UIKit

class ChecklistTableViewCell: UITableViewCell {
    
    lazy var checkmarkLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = self.tintColor
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setupView() {
        addSubview(checkmarkLabel)
//        checkmarkLabel.frame = CGRect(
//            origin:  CGPoint(x: 10, y: 0),
//            size: CGSize(width: 30, height: frame.height)
//        )
        checkmarkLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        checkmarkLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        checkmarkLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        checkmarkLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true


        addSubview(nameTextLabel)
        nameTextLabel.leftAnchor.constraint(equalTo: checkmarkLabel.rightAnchor).isActive = true
        nameTextLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameTextLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        nameTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        nameTextLabel.frame = CGRect(x: 40, y: 0, width: frame.width - 50, height: frame.height)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
