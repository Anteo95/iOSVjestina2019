//
//  TabViewController.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 22/05/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let quizListViewModel = QuizListViewModel()
        let quizListVC = QuizListViewController(viewModel: quizListViewModel)
        let quizListNavigationController = UINavigationController(rootViewController: quizListVC)
        let quizListTabBarItem = UITabBarItem(title: "Quiz List", image: UIImage(named: "list"), tag: 0)
        quizListNavigationController.tabBarItem = quizListTabBarItem
        
        let quizSerachViewModel = QuizListViewModel()
        let quizSerachVC = QuizSearchViewController(viewModel: quizSerachViewModel)
        let quizSearchNavigationController = UINavigationController(rootViewController: quizSerachVC)
        quizSearchNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        
        
        let settingsVC = SettingsViewController()
        let settingsTabBarItem = UITabBarItem(title: "User settings", image: UIImage(named: "user_male"), tag: 2)
        settingsVC.tabBarItem = settingsTabBarItem
        
        viewControllers = [quizListNavigationController, quizSearchNavigationController, settingsVC]
        
        selectedIndex = 0
    }
}
