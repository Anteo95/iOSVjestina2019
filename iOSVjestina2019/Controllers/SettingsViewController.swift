//
//  SettingsViewController.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 30/05/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let username =  UserDefaults.standard.string(forKey: "username")
        userLabel.text = username
    }
    
    @IBAction func logoutButtonTap(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "userId")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = LoginViewController()
    }
}
