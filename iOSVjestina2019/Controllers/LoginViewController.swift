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
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var keyboardHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareForAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateEverythingIn()
    }
    
    private func prepareForAnimating() {
        usernameTextField.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0)
        usernameTextField.alpha = 0.0
        
        passwordTextField.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0)
        passwordTextField.alpha = 0.0
        
        loginButton.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0)
        loginButton.alpha = 0.0
        
        titleLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
        titleLabel.alpha = 0.0
    }
    
    
    private func animateEverythingIn() {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.usernameTextField.transform = CGAffineTransform.identity
            self.usernameTextField.alpha = 1.0
        })
        
        UIView.animate(withDuration: 0.6, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.passwordTextField.transform = CGAffineTransform.identity
            self.passwordTextField.alpha = 1.0
        })
        
        UIView.animate(withDuration: 0.7, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.loginButton.transform = CGAffineTransform.identity
            self.loginButton.alpha = 1.0
        })
        
        UIView.animate(withDuration: 0.7, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.titleLabel.transform = CGAffineTransform.identity
            self.titleLabel.alpha = 1.0
        })
    }
    
    private func animateEverythingOut(completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.8, animations: {
            self.titleLabel.transform = CGAffineTransform(translationX: 0, y: -self.view.bounds.height)
            self.titleLabel.alpha = 0.0
        })
        
        UIView.animate(withDuration: 0.8, delay: 0.1, animations: {
            self.usernameTextField.transform = CGAffineTransform(translationX: 0, y: -self.view.bounds.height)
            self.usernameTextField.alpha = 0.0
        })
        
        UIView.animate(withDuration: 0.8, delay: 0.2, animations: {
            self.passwordTextField.transform = CGAffineTransform(translationX: 0, y: -self.view.bounds.height)
            self.passwordTextField.alpha = 0.0
        })
        
        UIView.animate(withDuration: 0.8, delay: 0.3, animations: {
            self.loginButton.transform = CGAffineTransform(translationX: 0, y: -self.view.bounds.height)
            self.loginButton.alpha = 0.0
        }, completion: completion)
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
            DispatchQueue.main.async {
                self.showAlert()
            }
            return
        }
        loginService.login(urlString: "https://iosquiz.herokuapp.com/api/session", username: username, password: password) { (arg) in
            guard let (token, userId) = arg else {
                DispatchQueue.main.async {
                    self.showAlert()
                }
                return
            }
            UserDefaults.standard.set(token, forKey: "token")
            UserDefaults.standard.set(userId, forKey: "userId")
            UserDefaults.standard.set(username, forKey: "username")
            
            DispatchQueue.main.async {
                self.animateEverythingOut { _ in
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window!.rootViewController = TabBarViewController()
                }
            }
        }
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Login", message: "Wrong username or password!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
}
