//
//  InitialViewController.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 29/03/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    let quizService = QuizService()
    var quizzes: [Quiz]? = nil
    var selectedQuiz: Quiz? = nil
    var selectedQuestion: Question? = nil
    
    var questionView: QuestionView? = nil
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBOutlet weak var fetchQuizzesButton: UIButton!
    @IBOutlet weak var funFactLabel: UILabel!
    @IBOutlet weak var quizTitleLabel: UILabel!
    @IBOutlet weak var quizImageView: UIImageView!
    @IBOutlet weak var questionViewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchQuizzesButton.layer.cornerRadius = fetchQuizzesButton.bounds.size.height / 2
    }
    
    @IBAction func onTapFetchQuizzes(_ sender: Any) {
        quizService.fetchQuizzes(urlString: "https://iosquiz.herokuapp.com/api/quizzes") { (quizzes) in
            self.quizzes = quizzes
            if let quizzes = quizzes {
                let nbaQuestions: [[Question]] = quizzes.map {
                    
                    let filteredQuestions: [Question] = $0.questions.filter {
                        return $0.question.contains("NBA")
                    }
                    return filteredQuestions
                }
                var nbaQuestionsCount = 0
                nbaQuestions.forEach {
                    print($0.count)
                    nbaQuestionsCount += $0.count
                }

                DispatchQueue.main.async {
                    self.funFactLabel.text = "Number of questions that contain word 'NBA' is: \(nbaQuestionsCount)"
                    self.funFactLabel.sizeToFit()
                }
                
                let quizIndex = Int.random(in: 0..<quizzes.count)
                let questionIndex = Int.random(in: 0..<quizzes[quizIndex].questions.count)
                
                self.selectedQuiz = quizzes[quizIndex]
                self.selectedQuestion = quizzes[quizIndex].questions[questionIndex]
                
                guard let selectedQuiz = self.selectedQuiz else {
                        return
                }
                
                if let quizImage = selectedQuiz.image {
                    self.quizService.fetchQuizImage(urlString: quizImage) { (image)  in
                        DispatchQueue.main.async {
                            self.quizImageView.image = image
                            self.quizImageView.backgroundColor = selectedQuiz.category.color
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.errorMessageLabel.isHidden = true
                    self.questionView?.isHidden = false
                    self.funFactLabel.isHidden = false
                    self.quizTitleLabel.isHidden = false
                    self.quizTitleLabel.text = selectedQuiz.title
                    self.quizTitleLabel.backgroundColor = selectedQuiz.category.color
                    if self.questionView == nil  {
                        self.addQuestionView()
                    } else {
                        self.setAnswerButtonsValues()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.funFactLabel.isHidden = true
                    self.quizTitleLabel.isHidden = true
                    self.questionView?.isHidden = true
                    self.errorMessageLabel.isHidden = false
                }
            }
        }
    }
    
    private func addQuestionView() {
        questionView = QuestionView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: questionViewContainer.frame.size))
        guard let questionView = questionView else {
            return
        }
        questionView.questionTextLabel?.text = selectedQuestion?.question
        for i in 0...3 {
            questionView.answerButtons[i].setTitle(selectedQuestion?.answers[i], for:UIControl.State.normal)
            questionView.answerButtons[i].addTarget(self, action: #selector(InitialViewController.onTapAnswerButton), for: UIControl.Event.touchUpInside)
        }
        questionViewContainer.addSubview(questionView)
    }
    
    private func setAnswerButtonsValues() {
        if let questionView = questionView {
            if let questionTextLabel = questionView.questionTextLabel {
                questionTextLabel.text = selectedQuestion?.question
            }
            for i in 0...3 {
                questionView.answerButtons[i].setTitle(selectedQuestion?.answers[i], for:UIControl.State.normal)
                questionView.answerButtons[i].backgroundColor = UIColor(red: 0.04, green: 0.478, blue: 1.0, alpha: 1.0)
            }
        }
    }
    
    @objc func onTapAnswerButton(_ sender: UIButton) {
        guard let index = questionView?.answerButtons.firstIndex(of: sender),
            let selectedQuestion = selectedQuestion else {
            return
        }
        if(index == selectedQuestion.correctAnswer) {
            questionView?.answerButtons[index].backgroundColor = UIColor(red: 0.230, green: 0.8, blue: 0.266, alpha: 1.0)
        } else {
            questionView?.answerButtons[index].backgroundColor = UIColor(red: 0.987, green: 0.210, blue: 0.208, alpha: 1.0)
        }
    }
    
}
