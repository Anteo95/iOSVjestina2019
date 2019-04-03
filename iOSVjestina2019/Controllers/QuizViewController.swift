//
//  InitialViewController.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 29/03/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
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
    @IBOutlet weak var logoutButton: UIButton!
    
    let neutralAnswerColor = UIColor(red: 0.04, green: 0.478, blue: 1.0, alpha: 1.0)
    let wrongAnswerColor = UIColor(red: 0.987, green: 0.210, blue: 0.208, alpha: 1.0)
    let correctAnswerColor = UIColor(red: 0.230, green: 0.8, blue: 0.266, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchQuizzesButton.layer.cornerRadius = fetchQuizzesButton.bounds.size.height / 2
    }
    
    @IBAction func onTapLogoutButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "token")
        let loginViewController = LoginViewController()
        self.present(loginViewController, animated:true, completion: nil)
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
                        self.updateQuestionView()
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
        if let questionView = questionView {
            questionView.setQuestionText(text: selectedQuestion?.question)
            for i in 0...3 {
                questionView.setButtontitle(at: i, title: selectedQuestion?.answers[i])
                questionView.getButton(at: i).addTarget(self, action: #selector(QuizViewController.onTapAnswerButton), for: UIControl.Event.touchUpInside)
            }
            questionViewContainer.addSubview(questionView)
        }
    }
    
    private func updateQuestionView() {
        if let questionView = questionView, let selectedQuestion = selectedQuestion {
            questionView.setQuestionText(text: selectedQuestion.question)
            for i in 0...3 {
                questionView.setButtonBackgroundColor(at: i, color: neutralAnswerColor)
                questionView.setButtontitle(at: i, title: selectedQuestion.answers[i])
            }
        }
    }
    
    @objc func onTapAnswerButton(_ sender: UIButton) {
        if let questionView = questionView, let selectedQuestion = selectedQuestion, let index = questionView.getIndex(of: sender) {
            if(index == selectedQuestion.correctAnswer) {
                questionView.setButtonBackgroundColor(at: index, color: correctAnswerColor)
            } else {
                questionView.setButtonBackgroundColor(at: index, color: wrongAnswerColor)
            }
        }
    }
    
}
