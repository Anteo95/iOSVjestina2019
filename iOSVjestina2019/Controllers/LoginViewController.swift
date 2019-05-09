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
    @IBOutlet weak var keyboardHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let keyboardSize = (notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardHeight = keyboardSize!.height
        keyboardHeightConstraint.constant = keyboardHeight
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        keyboardHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    
    @IBAction func onTapLoginButton(_ sender: Any) {
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            showAlert()
            return
        }
        loginService.login(urlString: "https://iosquiz.herokuapp.com/api/session", username: username, password: password) { (arg) in
            guard let (token, userId) = arg else {
                self.showAlert()
                return
            }
            UserDefaults.standard.set(token, forKey: "token")
            UserDefaults.standard.set(userId, forKey: "userId")
            DispatchQueue.main.async {
                let quizListViewModel = QuizListViewModel()
                let vc = QuizListViewController(viewModel: quizListViewModel)
                let navigationController = UINavigationController(rootViewController: vc)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window!.rootViewController = navigationController
            }
        }
    }
    
    private func showAlert() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Login", message: "Wrong username or password!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
