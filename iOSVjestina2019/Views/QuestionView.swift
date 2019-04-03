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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let labelOrigin = CGPoint(x: 10, y: 10)
        let labelSize = CGSize(width: frame.size.width, height: 100.0)

        questionTextLabel = UILabel(frame: CGRect(origin: labelOrigin, size: labelSize))
        
        if let questionTextLabel = questionTextLabel {
            questionTextLabel.textAlignment = NSTextAlignment.center
            questionTextLabel.numberOfLines = 0
            let font = questionTextLabel.font.withSize(24.0)
            questionTextLabel.font = font
            addSubview(questionTextLabel)
            
            let buttonWidth = frame.width - 10.0
            let buttonHeight: CGFloat = 50.0
    
            let buttonX: CGFloat = 10.0
            var buttonY = questionTextLabel.frame.height + 20.0
            
            var button = createButton(buttonX: buttonX, buttonY: buttonY, buttonWidth: buttonWidth, buttonHeight: buttonHeight)
            addSubview(button)
            answerButtons.append(button)
            
            buttonY += buttonHeight + 30
            
            button = createButton(buttonX: buttonX, buttonY: buttonY, buttonWidth: buttonWidth, buttonHeight: buttonHeight)
            addSubview(button)
            answerButtons.append(button)

            
            buttonY += buttonHeight + 30
            
            button = createButton(buttonX: buttonX, buttonY: buttonY, buttonWidth: buttonWidth, buttonHeight: buttonHeight)
            addSubview(button)
            answerButtons.append(button)
            
            buttonY += buttonHeight + 30
        
            button = createButton(buttonX: buttonX, buttonY: buttonY, buttonWidth: buttonWidth, buttonHeight: buttonHeight)
            addSubview(button)
            answerButtons.append(button)
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
    

    
    private func createButton(buttonX: CGFloat, buttonY: CGFloat, buttonWidth: CGFloat, buttonHeight: CGFloat)
        -> UIButton {
        let answerButton = UIButton(frame: CGRect(origin: CGPoint(x: buttonX, y: buttonY), size: CGSize(width: buttonWidth, height: buttonHeight)))
        answerButton.backgroundColor = UIColor(red: 0.04, green: 0.478, blue: 1.0, alpha: 1.0)
        answerButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        answerButton.layer.cornerRadius = answerButton.bounds.size.height / 3.0
        return answerButton
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
