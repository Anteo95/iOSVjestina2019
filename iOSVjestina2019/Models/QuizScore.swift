//
//  QuizResult.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 26/05/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import Foundation

struct QuizScore {
    let score: Double
    let username: String
    
    init?(json: Any) {
        if let jsonDict = json as? [String: Any],
            let score = jsonDict["score"] as? String,
            let username = jsonDict["username"] as? String {
            guard let scoreAsDouble = Double(score) else {
                return nil
            }
            self.score = scoreAsDouble
            self.username = username
        } else {
            return nil
        }
    }
}
