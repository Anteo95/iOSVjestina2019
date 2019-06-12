//
//  DataController.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 25/05/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    static let shared = DataController()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func fetchQuizList() -> [Quiz]? {
        let request: NSFetchRequest<Quiz> = Quiz.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let context = DataController.shared.persistentContainer.viewContext
        let quizList = try? context.fetch(request)
        return quizList
    }
    
    func searchQuizList(keyword: String) -> [Quiz]? {
        let request: NSFetchRequest<Quiz> = Quiz.fetchRequest()
        if(keyword != "") {
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@ || desc CONTAINS[cd] %@", keyword, keyword)
        }
        let context = DataController.shared.persistentContainer.viewContext
        let quizList = try? context.fetch(request)
        return quizList
    }
    
    func saveContext () {
        
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
