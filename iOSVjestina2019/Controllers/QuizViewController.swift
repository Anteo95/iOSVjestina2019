//
//  InitialViewController.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 29/03/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    @IBOutlet weak var quizTitleLabel: UILabel!
    @IBOutlet weak var quizImageView: UIImageView!
    @IBOutlet weak var questionScrollView: UIScrollView!
    @IBOutlet weak var startQuizButton: UIButton!
    
    var questionContentView = UIView()
    
    var quiz: Quiz? = nil
    var quizImage: UIImage? = nil
    var questionViews: [QuestionView] = []
    var currentQuestionIndex = 0
    
    var answeredCorrectly = 0
    
    var displayedQuestionIndex: Int = 0 {
        willSet {
            let size = questionScrollView.frame.size
            let frameWidth = size.width
            questionScrollView.setContentOffset(CGPoint(x: CGFloat(newValue) * frameWidth, y: CGFloat(0)), animated: true)
        }
    }
    
    var startTime: Date = Date()
    
    let neutralAnswerColor = UIColor(red: 0.04, green: 0.478, blue: 1.0, alpha: 1.0)
    let wrongAnswerColor = UIColor(red: 0.987, green: 0.210, blue: 0.208, alpha: 1.0)
    let correctAnswerColor = UIColor(red: 0.230, green: 0.8, blue: 0.266, alpha: 1.0)
    
    let quizService = QuizService()
    
    @IBAction func onTapStartQuiz(_ sender: Any) {
        startTime = Date()
        startQuizButton.isHidden = true
        questionScrollView.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionScrollView.addSubview(questionContentView)
        
        questionContentView.translatesAutoresizingMaskIntoConstraints = false
        questionContentView.topAnchor.constraint(equalTo: questionScrollView.topAnchor).isActive = true
        questionContentView.bottomAnchor.constraint(equalTo: questionScrollView.bottomAnchor).isActive = true
        questionContentView.leadingAnchor.constraint(equalTo: questionScrollView.leadingAnchor).isActive = true
        questionContentView.trailingAnchor.constraint(equalTo: questionScrollView.trailingAnchor).isActive = true
        questionContentView.heightAnchor.constraint(equalTo: questionScrollView.heightAnchor).isActive = true
        
        if let quiz = quiz {
            quizTitleLabel.text = quiz.title
            if let quizImage = quizImage {
                quizImageView.image = quizImage
            }
            for questionIndex in 0..<quiz.questions.count {
                let qv = QuestionView()
                questionViews.append(qv)
                questionContentView.addSubview(qv)
                let question = quiz.questions[questionIndex]
                qv.setQuestionText(text: question.question)
                qv.setButtontitle(at: 0, title: question.answers[0])
                qv.setButtontitle(at: 1, title: question.answers[1])
                qv.setButtontitle(at: 2, title: question.answers[2])
                qv.setButtontitle(at: 3, title: question.answers[3])
                qv.delegate = self
                if questionIndex == 0 {
                    qv.translatesAutoresizingMaskIntoConstraints = false
                    qv.leadingAnchor.constraint(equalTo: questionContentView.leadingAnchor).isActive = true
                    qv.topAnchor.constraint(equalTo: questionContentView.topAnchor).isActive = true
                    qv.widthAnchor.constraint(equalTo: questionScrollView.widthAnchor).isActive = true
                    qv.heightAnchor.constraint(equalTo: questionScrollView.heightAnchor).isActive = true
                } else if questionIndex != quiz.questions.count - 1 {
                    qv.translatesAutoresizingMaskIntoConstraints = false
                    qv.leadingAnchor.constraint(equalTo: questionViews[questionIndex - 1].trailingAnchor).isActive = true
                    qv.topAnchor.constraint(equalTo: questionContentView.topAnchor).isActive = true
                    qv.widthAnchor.constraint(equalTo: questionScrollView.widthAnchor).isActive = true
                    qv.heightAnchor.constraint(equalTo: questionScrollView.heightAnchor).isActive = true
                } else {
                    qv.translatesAutoresizingMaskIntoConstraints = false
                    qv.leadingAnchor.constraint(equalTo: questionViews[questionIndex - 1].trailingAnchor).isActive = true
                    qv.topAnchor.constraint(equalTo: questionContentView.topAnchor).isActive = true
                    qv.widthAnchor.constraint(equalTo: questionScrollView.widthAnchor).isActive = true
                    qv.heightAnchor.constraint(equalTo: questionScrollView.heightAnchor).isActive = true
                    qv.trailingAnchor.constraint(equalTo: questionContentView.trailingAnchor).isActive = true
                }
            }
        }
    }
}

extension QuizViewController: QuestionViewDelegate {
    func answerTapped(tag: Int) {
        let qv = questionViews[currentQuestionIndex]
        guard let quiz = quiz else {
            return
        }
        let correctAnswerIndex = quiz.questions[currentQuestionIndex].correctAnswer
        if tag == correctAnswerIndex {
            answeredCorrectly += 1
            qv.setButtonBackgroundColor(at: tag, color: correctAnswerColor)
        } else {
            qv.setButtonBackgroundColor(at: tag, color: wrongAnswerColor)
            qv.setButtonBackgroundColor(at: correctAnswerIndex, color: correctAnswerColor)
        }
        currentQuestionIndex += 1
        if currentQuestionIndex >= quiz.questions.count {
            print("correct: \(answeredCorrectly)")
            let endTime = Date()
            let timeElapsed = endTime.timeIntervalSince(startTime)
            print("Time elapsed: \(timeElapsed)")
            sendQuizResult()
            navigationController?.popViewController(animated: true)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.displayedQuestionIndex = self.currentQuestionIndex
            }
        }
    }
    
    private func sendQuizResult() {
        guard let quiz = quiz else { return }
        let userId = UserDefaults.standard.integer(forKey: "userId")
        quizService.sendQuizResult(urlString: "https://iosquiz.herokuapp.com/api/result", quizId: quiz.id, userId: userId, time: 15.4, numOfCorrect: 7) { (status) in
            
        }
    }
}
