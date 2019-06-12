//
//  Quiz.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 30/03/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import Foundation
import UIKit


enum QuizCategory: String {
    case sports = "SPORTS"
    case science = "SCIENCE"
    
    var color: UIColor  {
        switch self {
        case .sports:
            return UIColor(red: 0.992, green: 0.599, blue: 0.074, alpha: 1.0)
        case .science:
            return UIColor(red: 0.997, green: 0.862, blue: 0.077, alpha: 1.0)
        }
    }
}

//class Quiz {
//    let category: QuizCategory
//    let description: String?
//    let id: Int
//    let image: String?
//    let level: Int
//    var questions: [Question] = []
//    let title: String
//    
//    init?(json: Any) {
//        if let jsonDict = json as? [String: Any],
//            let category = jsonDict["category"] as? String,
//            //let description = jsonDict["description"] as? String?,
//            let id = jsonDict["id"] as? Int,
//            let level = jsonDict["level"] as? Int,
//            let title = jsonDict["title"] as? String,
//            let questions = jsonDict["questions"] as? [Any] {
//            for question in questions {
//                guard let question = Question(json: question) else {
//                    return nil
//                }
//                self.questions.append(question)
//            }
//            guard let quizCategory = QuizCategory(rawValue: category) else {
//                return nil
//            }
//            self.category = quizCategory
//            self.description = jsonDict["description"] as? String
//            self.id = id
//            self.image = jsonDict["image"] as? String
//            self.level = level
//            self.title = title
//        } else {
//            return nil
//        }
//    }
//}
