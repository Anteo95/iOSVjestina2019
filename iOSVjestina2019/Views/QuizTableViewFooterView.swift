//
//  QuizTableViewFooterView.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 09/05/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

protocol TableViewFooterViewDelegate: class {
    func logoutBtnTapped()
}

class QuizTableViewFooterView: UIView {
    var logoutButton: UIButton!
    weak var delegate: TableViewFooterViewDelegate?
    
    @objc func logoutBtnTapped() {
        delegate?.logoutBtnTapped()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 0.0, green: 0.6, blue: 0.8, alpha: 1.0)
        
        logoutButton = UIButton()
        addSubview(logoutButton)
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        logoutButton.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        logoutButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        logoutButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        logoutButton.setTitle("Logout", for: UIControl.State.normal)
        logoutButton.addTarget(self, action: #selector(QuizTableViewFooterView.logoutBtnTapped), for: UIControl.Event.touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
