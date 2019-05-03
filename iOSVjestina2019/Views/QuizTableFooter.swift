//
//  QuizTableFooter.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 26/04/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

class QuizTableFooter: UIView {
    
    let logoutButton = UIButton.init()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        logoutButton.titleLabel?.text = "logout"
        
        addSubview(logoutButton)
    }
}

