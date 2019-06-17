//
//  TabViewController.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 22/05/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = UIColor(red: 0.0, green: 0.6, blue: 0.8, alpha: 1.0)
        tabBar.isTranslucent = false
        tabBar.tintColor = .red
        tabBar.unselectedItemTintColor = .white
        
        let quizListViewModel = QuizListViewModel()
        let quizListVC = QuizListViewController(viewModel: quizListViewModel)
        let quizListNavigationController = UINavigationController(rootViewController: quizListVC)
        
        quizListNavigationController.navigationBar.tintColor = UIColor.white
        quizListNavigationController.navigationBar.barTintColor = UIColor(red: 0.0, green: 0.6, blue: 0.8, alpha: 1.0)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.red]
        quizListNavigationController.navigationBar.titleTextAttributes = textAttributes

        let quizListTabBarItem = UITabBarItem(title: "Quiz List", image: UIImage(named: "list"), tag: 0)
        quizListNavigationController.tabBarItem = quizListTabBarItem
        
        let quizSerachViewModel = QuizListViewModel()
        let quizSerachVC = QuizSearchViewController(viewModel: quizSerachViewModel)
        
        let quizSearchNavigationController = UINavigationController(rootViewController: quizSerachVC)
        quizSearchNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        
        quizSearchNavigationController.navigationBar.tintColor = UIColor.white
        quizSearchNavigationController.navigationBar.barTintColor = UIColor(red: 0.0, green: 0.6, blue: 0.8, alpha: 1.0)
        quizSearchNavigationController.navigationBar.titleTextAttributes = textAttributes
        
        
        let settingsVC = SettingsViewController()
        let settingsTabBarItem = UITabBarItem(title: "User settings", image: UIImage(named: "user_male"), tag: 2)
        settingsVC.tabBarItem = settingsTabBarItem
        
        viewControllers = [quizListNavigationController, quizSearchNavigationController, settingsVC]
        
        selectedIndex = 0
    }
}
