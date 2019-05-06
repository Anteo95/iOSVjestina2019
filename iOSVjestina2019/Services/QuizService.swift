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
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            var quizzes: [Quiz] = []
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonDict = json as? [String: Any], let jsonQuizzes = jsonDict["quizzes"] as? [Any] else {
                    completion(nil)
                    return
                }
                jsonQuizzes.forEach {
                    if let quiz = Quiz(json: $0) {
                        quizzes.append(quiz)
                    }
                }
                completion(quizzes)
            } catch {
                completion(nil)
            }
        }
        dataTask.resume()
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
    
    func sendQuizResult(urlString: String, quizId: Int, userId: Int, time: Double, numOfCorrect: Int, completion: @escaping (HTTPResponseStatus?) -> Void) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            guard let token = UserDefaults.standard.string(forKey: "token") else {
                return
            }
            request.addValue(token, forHTTPHeaderField: "Authorization")
            let parameters: [String: Any] = [
                "quiz_id": quizId,
                "user_id": userId,
                "time:": time,
                "no_of_correct": numOfCorrect
            ]
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
                completion(nil)
            }

            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let response = response as? HTTPURLResponse {
                    let status = HTTPResponseStatus(rawValue: response.statusCode)
                    completion(status)
                } else {
                    completion(nil)
                }
            }
            dataTask.resume()
        }
    }
}


enum HTTPResponseStatus: Int {
    case ok = 200
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
}
