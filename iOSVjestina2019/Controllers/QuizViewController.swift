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
    var scrollContentView: UIView!
    var questionViews: [QuestionView] = []


    var viewModel: QuizViewModel!
    
    var correctAnswersCount = 0
    
    var displayedQuestionIndex: Int = 0 {
        willSet {
            let size = questionScrollView.frame.size
            let frameWidth = size.width
            questionScrollView.setContentOffset(CGPoint(x: CGFloat(newValue) * frameWidth, y: CGFloat(0)), animated: true)
        }
    }
    
    var startTime: Date = Date()
    
    var quizResult: QuizResult?
    
    let neutralAnswerColor = UIColor(red: 0.0, green: 0.6, blue: 0.8, alpha: 1.0)
    let wrongAnswerColor = UIColor(red: 0.987, green: 0.210, blue: 0.208, alpha: 1.0)
    let correctAnswerColor = UIColor(red: 0.230, green: 0.8, blue: 0.266, alpha: 1.0)
    
    let quizService = QuizService()
    
    convenience init(viewModel: QuizViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Quiz"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Leaderboards", style: .plain, target: self, action: #selector(onTapViewLeaderboard))
        setupQuestionViews()
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let viewControllers = navigationController?.viewControllers {
            if viewControllers[viewControllers.count - 1] == self {
            } else {
                viewModel.closeQuiz()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let viewControllers = navigationController?.viewControllers {
            if viewControllers[viewControllers.count - 1] == self {
                
            }
        }
        
    }
    
    
    
    private func setupQuestionViews() {
        scrollContentView = UIView()
        questionScrollView.addSubview(scrollContentView)
        
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.topAnchor.constraint(equalTo: questionScrollView.topAnchor).isActive = true
        scrollContentView.bottomAnchor.constraint(equalTo: questionScrollView.bottomAnchor).isActive = true
        scrollContentView.leadingAnchor.constraint(equalTo: questionScrollView.leadingAnchor).isActive = true
        scrollContentView.trailingAnchor.constraint(equalTo: questionScrollView.trailingAnchor).isActive = true
        scrollContentView.heightAnchor.constraint(equalTo: questionScrollView.heightAnchor).isActive = true
        
        for index in 0..<viewModel.numberOfQuestions {
            let qv = QuestionView()
            questionViews.append(qv)
            scrollContentView.addSubview(qv)
            
            qv.delegate = self
            
            if index == 0 {
                qv.translatesAutoresizingMaskIntoConstraints = false
                qv.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor).isActive = true
                qv.topAnchor.constraint(equalTo: scrollContentView.topAnchor).isActive = true
                qv.widthAnchor.constraint(equalTo: questionScrollView.widthAnchor).isActive = true
                qv.heightAnchor.constraint(equalTo: questionScrollView.heightAnchor).isActive = true
            } else if index != viewModel.numberOfQuestions - 1 {
                qv.translatesAutoresizingMaskIntoConstraints = false
                qv.leadingAnchor.constraint(equalTo: questionViews[index - 1].trailingAnchor).isActive = true
                qv.topAnchor.constraint(equalTo: scrollContentView.topAnchor).isActive = true
                qv.widthAnchor.constraint(equalTo: questionScrollView.widthAnchor).isActive = true
                qv.heightAnchor.constraint(equalTo: questionScrollView.heightAnchor).isActive = true
            } else {
                qv.translatesAutoresizingMaskIntoConstraints = false
                qv.leadingAnchor.constraint(equalTo: questionViews[index - 1].trailingAnchor).isActive = true
                qv.topAnchor.constraint(equalTo: scrollContentView.topAnchor).isActive = true
                qv.widthAnchor.constraint(equalTo: questionScrollView.widthAnchor).isActive = true
                qv.heightAnchor.constraint(equalTo: questionScrollView.heightAnchor).isActive = true
                qv.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor).isActive = true
            }
        }
    }
    
    private func bindViewModel() {
        quizTitleLabel.text = viewModel.quizTitle
        quizImageView.kf.setImage(with: viewModel.imageUrl)
        questionViews.enumerated().forEach {
            $0.element.populate(with: viewModel.questionViewModel(forIndex: $0.offset))
        }
    }
    
    @objc func onTapViewLeaderboard() {
        let leaderboardViewModel = viewModel.leaderboardViewModel()
        let leaderboardViewController = LeaderboardViewController(viewModel: leaderboardViewModel)
        present(leaderboardViewController, animated: true, completion: nil)
    }
    
    @IBAction func onTapStartQuiz(_ sender: Any) {
        if viewModel.quizOpened {
            print("already opened")
            return
        }
        viewModel.openQuiz()
        startTime = Date()
        startQuizButton.isHidden = true
        questionScrollView.isHidden = false
    }
}

extension QuizViewController: QuestionViewDelegate {
    func answerTapped(tag: Int) {
        let qv = questionViews[displayedQuestionIndex]
        let correctAnswerIndex = viewModel.correctAnswer(forIndex: displayedQuestionIndex)
        
        if tag == correctAnswerIndex {
            correctAnswersCount += 1
            qv.setButtonBackgroundColor(at: tag, color: correctAnswerColor)
        } else {
            qv.setButtonBackgroundColor(at: tag, color: wrongAnswerColor)
            qv.setButtonBackgroundColor(at: correctAnswerIndex, color: correctAnswerColor)
        }
        
        if displayedQuestionIndex == viewModel.numberOfQuestions - 1 {
            let endTime = Date()
            let timeElapsed = endTime.timeIntervalSince(startTime)
            let quizId = viewModel.quizId
            let userId = UserDefaults.standard.integer(forKey: "userId")
            quizResult = QuizResult(quizId: quizId, userId: userId, time: timeElapsed, numOfCorrect: correctAnswersCount)
            sendQuizResult()
        } else {
            self.view.isUserInteractionEnabled = false;
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.displayedQuestionIndex += 1
                self.view.isUserInteractionEnabled = true;
            }
        }
    }
    
    private func sendQuizResult() {
        guard let quizResult = quizResult else {
            return
        }
        quizService.sendQuizResult(urlString: "https://iosquiz.herokuapp.com/api/result", quizResult: quizResult) { [weak self] (status) in
            if let status = status {
                switch (status) {
                case .ok:
                    DispatchQueue.main.async {
                        self?.navigationController?.popViewController(animated: true)
                    }
                default:
                    DispatchQueue.main.async {
                        self?.showAlert()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.showAlert()
                }
            }
        }
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Result", message: "Error occured when trying to send results!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Send again", style: .default, handler:  { [weak self] _ in
            self?.sendQuizResult()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler:  { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
