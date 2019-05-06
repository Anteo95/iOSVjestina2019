//
//  QuizListViewController.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 20/04/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

class QuizListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var quizTable: UITableView!
    
    struct Section {
        var items: [Quiz]
        var images: [UIImage?]
        var category: QuizCategory
        
        init(category: QuizCategory) {
            self.category = category
            self.items = []
            self.images = []
        }
    }
    var sections: [Section] = []
    let quizService = QuizService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quizTable.isHidden = true
        
        let nib = UINib.init(nibName: "QuizTableViewCell", bundle: nil)
        quizTable.register(nib, forCellReuseIdentifier: "QuizTableViewCell")
        quizTable.register(QuizTableHeader.self, forHeaderFooterViewReuseIdentifier: QuizTableHeader.reuseIdentifier)
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        footerView.backgroundColor = UIColor(red: 0.0, green: 0.6, blue: 0.8, alpha: 1.0)
        
        let button = UIButton()
        footerView.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: footerView.widthAnchor).isActive = true
        button.heightAnchor.constraint(equalTo: footerView.heightAnchor).isActive = true
        
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.setTitle("Logout", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(onTapLogout), for: UIControl.Event.touchUpInside)
        
        quizTable.tableFooterView = footerView
    
        quizService.fetchQuizzes(urlString: "https://iosquiz.herokuapp.com/api/quizzes") { (quizzes) in
            self.createSectionsFromQuizzes(quizzes: quizzes)
            DispatchQueue.main.async {
                self.quizTable.delegate = self
                self.quizTable.dataSource = self
                self.quizTable.reloadData()
                self.quizTable.isHidden = false
            }
        }
    }
    
    @objc private func onTapLogout() {
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "userId")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = LoginViewController()
    }
    
    private func createSectionsFromQuizzes(quizzes: [Quiz]?) {
        var sectionOfCategory: [QuizCategory: Int] = [:]
        quizzes?.forEach { (quiz) in
            if let section = sectionOfCategory[quiz.category] {
                self.sections[section].items.append(quiz)
                self.sections[section].images.append(nil)
            } else {
                let section = self.sections.count
                sectionOfCategory[quiz.category] = section
                self.sections.append(Section(category: quiz.category))
                self.sections[section].items.append(quiz)
                self.sections[section].images.append(nil)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = QuizViewController()
        vc.quiz = sections[indexPath.section].items[indexPath.row]
        vc.quizImage = sections[indexPath.section].images[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: QuizTableHeader.reuseIdentifier) as! QuizTableHeader
        header.titleLabel.text = sections[section].category.rawValue
        header.contentView.backgroundColor = sections[section].category.color
        return header
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = quizTable.dequeueReusableCell(withIdentifier: "QuizTableViewCell", for: indexPath) as! QuizTableViewCell
        let quiz = sections[indexPath.section].items[indexPath.row]
        cell.titleLabel.text = quiz.title
        cell.descriptionLabel.text = quiz.description
        switch quiz.level {
            case 1:
                cell.levelLabel.text = "✭"
            case 2:
                cell.levelLabel.text = "✭✭"
            default:
                cell.levelLabel.text = "✭✭✭"
        }
        if let imageURL = quiz.image {
            if let image = sections[indexPath.section].images[indexPath.row] {
                cell.quizImage.image = image
            } else {
                quizService.fetchQuizImage(urlString: imageURL) { (image) in
                    DispatchQueue.main.async {
                        self.sections[indexPath.section].images[indexPath.row] = image
                        cell.quizImage.image = image
                    }
                }
            }
        }
        return cell

    }
}
