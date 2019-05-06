//
//  QuestionView.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 02/04/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

class QuestionView: UIView {
    
    var questionTextLabel: UILabel?
    var answerButtons: [UIButton] = []
    weak var delegate: QuestionViewDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        

        
        questionTextLabel = UILabel()
        if let questionTextLabel = questionTextLabel {
            addSubview(questionTextLabel)
            questionTextLabel.translatesAutoresizingMaskIntoConstraints = false
            questionTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
            questionTextLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
            questionTextLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
            questionTextLabel.textAlignment = NSTextAlignment.center
            questionTextLabel.numberOfLines = 0
            let font = questionTextLabel.font.withSize(18.0)
            questionTextLabel.font = font
            
            let btn0 = createButton(tag: 0)
            addSubview(btn0)
            answerButtons.append(btn0)
            
            btn0.translatesAutoresizingMaskIntoConstraints = false
            btn0.topAnchor.constraint(equalTo: questionTextLabel.bottomAnchor, constant: 8).isActive = true
            btn0.leadingAnchor.constraint(equalTo:  self.leadingAnchor, constant: 8).isActive = true
            btn0.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
            btn0.heightAnchor.constraint(lessThanOrEqualToConstant: 50).isActive = true
            
            let btn1 = createButton(tag: 1)
            addSubview(btn1)
            answerButtons.append(btn1)

            
            btn1.translatesAutoresizingMaskIntoConstraints = false
            btn1.topAnchor.constraint(equalTo: btn0.bottomAnchor, constant: 16).isActive = true
            btn1.leadingAnchor.constraint(equalTo:  self.leadingAnchor, constant: 8).isActive = true
            btn1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
            btn1.heightAnchor.constraint(equalTo: btn0.heightAnchor).isActive = true
            
            let btn2 = createButton(tag: 2)
            addSubview(btn2)
            answerButtons.append(btn2)

            
            btn2.translatesAutoresizingMaskIntoConstraints = false
            btn2.topAnchor.constraint(equalTo: btn1.bottomAnchor, constant: 16).isActive = true
            btn2.leadingAnchor.constraint(equalTo:  self.leadingAnchor, constant: 8).isActive = true
            btn2.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
            btn2.heightAnchor.constraint(equalTo: btn0.heightAnchor).isActive = true
            
            let btn3 = createButton(tag: 3)
            addSubview(btn3)
            answerButtons.append(btn3)

            
            btn3.translatesAutoresizingMaskIntoConstraints = false
            btn3.topAnchor.constraint(equalTo: btn2.bottomAnchor, constant: 16).isActive = true
            btn3.leadingAnchor.constraint(equalTo:  self.leadingAnchor, constant: 8).isActive = true
            btn3.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
            btn3.heightAnchor.constraint(equalTo: btn0.heightAnchor).isActive = true
            btn3.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
            
        }
    }
    
    func setButtonBackgroundColor(at index: Int, color: UIColor) {
        assert(index >= 0 && index < answerButtons.count)
        answerButtons[index].backgroundColor = color
    }
    
    func setButtontitle(at index: Int, title: String?) {
        assert(index >= 0 && index < answerButtons.count)
        answerButtons[index].setTitle(title, for: UIControl.State.normal)
    }
    
    func setQuestionText(text: String?) {
        questionTextLabel?.text = text
    }
    
    func getIndex(of button: UIButton) -> Int? {
        return answerButtons.firstIndex(of: button)
    }
    
    func getButton(at index: Int) -> UIButton {
        assert(index >= 0 && index < answerButtons.count)
        return answerButtons[index]
    }
    
    @objc private func answerTapped(sender: UIButton) {
        delegate?.answerTapped(tag: sender.tag)
    }
    
    private func createButton(tag: Int) -> UIButton {
        let answerButton = UIButton()
        answerButton.backgroundColor = UIColor(red: 0.04, green: 0.478, blue: 1.0, alpha: 1.0)
        answerButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        answerButton.layer.cornerRadius = 50.0 / 3.0
        answerButton.tag = tag
        answerButton.addTarget(self, action: #selector(answerTapped), for: UIControl.Event.touchUpInside)
        return answerButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


protocol QuestionViewDelegate: class {
    func answerTapped(tag: Int)
}
