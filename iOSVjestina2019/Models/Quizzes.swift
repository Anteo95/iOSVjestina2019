//
//  Quizzes.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 30/03/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import Foundation

class Quizzes {
    var quizzes: [Quiz] = []
    
    init?(json: Any) {
        if let jsonDict = json as? [String: Any],
        let quizzes = jsonDict["quizzes"] as? [Any] {
            for quiz in quizzes {
                guard let quiz = Quiz(json: quiz) else {
                    print("Nil in quizzes guard")
                    return nil
                }
                self.quizzes.append(quiz)
            }
        } else {
            print("Nil in quizzes")
            return nil
        }
    }
    
}
