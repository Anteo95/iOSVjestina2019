//
//  QuizListViewModel.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 08/05/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import Foundation




class QuizListViewModel {
    
    struct Section {
        var items: [Quiz]
        var category: QuizCategory
        
        init(category: QuizCategory) {
            self.category = category
            self.items = []
        }
    }
    
    private var items: [Quiz]? = nil
    private var sections: [Section] = []
    
    
    func fetchQuizList(completion: @escaping () -> Void) {
        let quizService = QuizService()
        quizService.fetchQuizzes(urlString: "https://iosquiz.herokuapp.com/api/quizzes") { [weak self] (quizList) in
            self?.items = DataController.shared.fetchQuizList()
            self?.createSections()
            completion()
        }
    }
    
    func searchQuizList(keyword: String) {
        self.items = DataController.shared.searchQuizList(keyword: keyword)
        self.createSections()
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func quizCellData(atIndexPath indexPath: IndexPath) -> QuizCellData? {
        guard items != nil else {
            return nil
        }
        let quiz = sections[indexPath.section].items[indexPath.row]
        return QuizCellData(imageUrl: quiz.imageUrl, title: quiz.title ??   "", description: quiz.desc, level: Int(quiz.level))
    }
    
    func quizHeaderData(forSection section: Int) -> QuizHeaderData? {
        guard items != nil else {
            return nil
        }
        return QuizHeaderData(title: sections[section].category.rawValue, backgroundColor: sections[section].category.color)
    }
    
    func quizViewModel(forIndexPath indexPath: IndexPath) -> QuizViewModel {
        return QuizViewModel(quiz: sections[indexPath.section].items[indexPath.row])
    }
    
    private func createSections() {
        sections.removeAll()
        var sectionOfCategory: [QuizCategory: Int] = [:]
        items?.forEach { (quiz) in
            if let section = sectionOfCategory[quiz.quizCategory] {
                self.sections[section].items.append(quiz)
            } else {
                let section = self.sections.count
                sectionOfCategory[quiz.quizCategory] = section
                self.sections.append(Section(category: quiz.quizCategory))
                self.sections[section].items.append(quiz)
            }
        }
    }
    
}
