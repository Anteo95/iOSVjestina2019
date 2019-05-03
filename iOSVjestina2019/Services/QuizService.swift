//
//  QuizService.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 29/03/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import Foundation
import UIKit

class QuizService {
    func fetchQuizzes(urlString: String, completion: @escaping ([Quiz]?) -> Void) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    var quizzes: [Quiz] = []
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let jsonDict = json as? [String: Any],
                            let jsonQuizzes = jsonDict["quizzes"] as? [Any] {
                            for jsonQuiz in jsonQuizzes {
                                if let quiz = Quiz(json: jsonQuiz) {
                                    quizzes.append(quiz)
                                } else {
                                    completion(nil)
                                }
                            }
                        } else {
                            completion(nil)
                        }
                        completion(quizzes)
                    } catch {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
            dataTask.resume()
        } else {
            completion(nil)
        }
    }
    
    func fetchQuizImage(urlString: String, completion: @escaping(UIImage?) -> Void) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    let image = UIImage(data: data)
                    completion(image)
                } else {
                    completion(nil)
                }
            }
            dataTask.resume()
        }
    }
    
    func sendQuizResult(urlString: String, quizId: Int, userId: Int, time: Double, numOfCorrect: Int) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let parameters: [String: Any] = [
                "quiz_id": quizId,
                "user_id": userId,
                "time:": time,
                "no_of_correct": numOfCorrect
            ]
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            guard let token = UserDefaults.standard.string(forKey: "token") else {
                return
            }
            request.addValue(token, forHTTPHeaderField: "Authorization")
            request.httpBody = parameters.percentEscaped().data(using: .utf8)
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            }
            dataTask.resume()
        }
    }
}
