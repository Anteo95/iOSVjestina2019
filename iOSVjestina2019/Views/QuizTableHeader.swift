//
//  QuizTableHeader.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 26/04/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

class QuizTableHeader: UITableViewHeaderFooterView {
    static let reuseIdentifier = "QuizTableHeader"
    let titleLabel = UILabel.init()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
