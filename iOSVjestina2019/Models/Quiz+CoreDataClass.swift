//
//  Quiz+CoreDataClass.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 30/05/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Quiz)
public class Quiz: NSManagedObject {
    
    class func firstOrCreate(withId id: Int) -> Quiz? {
        let context = DataController.shared.persistentContainer.viewContext
        let request: NSFetchRequest<Quiz> = Quiz.fetchRequest()
        request.predicate = NSPredicate(format: "id = %d", id)
        request.returnsObjectsAsFaults = false
        do {
            let quizList = try context.fetch(request)
            if let quiz = quizList.first {
                return quiz
            } else {
                let newQuiz = Quiz(context: context)
                return newQuiz
            }
        } catch {
            return nil
        }
    }
    
    class func createFrom(json: [String: Any]) -> Quiz? {
        if
            let category = json["category"] as? String,
            let description = json["description"] as? String?,
            let id = json["id"] as? Int,
            let level = json["level"] as? Int,
            let title = json["title"] as? String,
            let questions = json["questions"] as? [[String: Any]] {
            
            if let quiz = firstOrCreate(withId: id) {
                quiz.category = category
                quiz.desc = description
                quiz.id = Int32(id)
                quiz.imageUrl = json["image"] as? String
                quiz.level = Int32(level)
                quiz.title = title
                quiz.opened = false
                
                for questionJson in questions {
                    guard let question = Question.createFrom(json: questionJson) else {
                        return nil
                    }
                    quiz.addToQuestions(question)
                }
                
                do {
                    let context = DataController.shared.persistentContainer.viewContext
                    try context.save()
                    return quiz
                } catch {
                    print("Failed saving")
                }
            }
        }
        return nil
    }
}
