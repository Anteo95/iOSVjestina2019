//
//  LoginViewController.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 03/04/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let loginService = LoginService()
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func onTapLoginButton(_ sender: Any) {
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Login", message: "Wrong username or password!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
                self.present(alertController, animated: true, completion: nil)
            }
            return
        }
        loginService.login(urlString: "https://iosquiz.herokuapp.com/api/session", username: username, password: password) { (token) in
            if let token = token {
                UserDefaults.standard.set(token, forKey: "token")
                DispatchQueue.main.async {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window!.rootViewController = QuizViewController()
                }
            } else {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Login", message: "Wrong username or password!", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
