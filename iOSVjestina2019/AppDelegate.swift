//
//  AppDelegate.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 29/03/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        if let _ = UserDefaults.standard.string(forKey: "token") {
            window?.rootViewController = TabBarViewController()
            window?.makeKeyAndVisible()
        } else {
            let vc = LoginViewController()
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        }
        return true
    }
}

