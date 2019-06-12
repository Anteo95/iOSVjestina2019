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
        let questions = quiz.questions?.array as! [Question]
        self.questions = questions
    }
    
    var quizTitle: String {
        return quiz.title?.uppercased() ?? ""
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
    
    var quizOpened: Bool {
         return quiz.opened
    }
    
    var numberOfQuestions: Int {
        return quiz.questions?.count ?? 0
    }
    
    func question(forIndex index: Int) -> String {
        return questions[index].question ?? ""
        //return quiz.questions?[index].question
    }
    
    func questionAnswers(forIndex index: Int) -> [String] {
        return questions[index].answers ?? []
        //return quiz.questions?[index].answers
    }
    
    func correctAnswer(forIndex index: Int) -> Int {
        return Int(questions[index].correctAnswer)
//        return quiz.questions?[index].correctAnswer
    }
    
    func questionViewModel(forIndex index: Int) -> QuestionViewModel {
        return QuestionViewModel(questionText: questions[index].question ?? "" , answers: questions[index].answers ?? [])
//        return QuestionViewModel(questionText: quiz.questions[index].question, answers: quiz.questions[index].answers)
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
