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
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        let quizzes = Quizzes(json: json)
                        completion(quizzes?.quizzes)
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
}
