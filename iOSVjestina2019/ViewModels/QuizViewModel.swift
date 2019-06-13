//
//  QuizViewModel.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 09/05/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import Foundation

struct QuestionViewModel {
    var questionText: String
    var answers: [String]
    
    init(questionText: String, answers: [String]) {
        self.questionText = questionText
        self.answers = answers
    }
}

class QuizViewModel {
    private var quiz: Quiz
    private var questions: [Question]
    
    init(quiz: Quiz) {
        self.quiz = quiz
        self.questions = quiz.questions.array as! [Question]
    }
    
    var quizTitle: String {
        return quiz.title
    }
    
    var imageUrl: URL? {
        if let url = quiz.imageUrl {
            return URL(string: url)
        } else {
            return nil
        }
    }
    
    var quizId: Int {
        return Int(quiz.id)
    }
    
    var numberOfQuestions: Int {
        return quiz.questions.count
    }
    
    var quizOpened: Bool {
        return quiz.opened
    }
    
    
    func correctAnswer(forIndex index: Int) -> Int {
        return Int(questions[index].correctAnswer)
    }
    
    func questionViewModel(forIndex index: Int) -> QuestionViewModel {
        return QuestionViewModel(questionText: questions[index].question, answers: questions[index].answers)
    }
    
    func leaderboardViewModel() -> LeaderboardViewModel {
        return LeaderboardViewModel(forQuiz: quiz)
    }
    
    func openQuiz() {
        quiz.opened = true
        //DataController.shared.saveContext()
    }
    
    func closeQuiz() {
        quiz.opened = false
    }
}
