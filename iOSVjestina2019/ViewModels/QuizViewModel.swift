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
    
    init(quiz: Quiz) {
        self.quiz = quiz
    }
    
    var quizTitle: String {
        return quiz.title.uppercased()
    }
    
    var imageUrl: URL? {
        if let url = quiz.image {
            return URL(string: url)
        } else {
            return nil
        }
    }
    
    var quizId: Int {
        return quiz.id
    }
    
    var numberOfQuestions: Int {
        return quiz.questions.count
    }
    
    func question(forIndex index: Int) -> String {
        return quiz.questions[index].question
    }
    
    func questionAnswers(forIndex index: Int) -> [String] {
        return quiz.questions[index].answers
    }
    
    func correctAnswer(forIndex index: Int) -> Int {
        return quiz.questions[index].correctAnswer
    }
    
    func questionViewModel(forIndex index: Int) -> QuestionViewModel {
        return QuestionViewModel(questionText: quiz.questions[index].question, answers: quiz.questions[index].answers)
    }
}
