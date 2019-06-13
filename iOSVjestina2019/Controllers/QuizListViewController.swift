//
//  QuizListViewController.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 20/04/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

class QuizListViewController: UIViewController {

    @IBOutlet weak var quizTable: UITableView!
    
    var viewModel: QuizListViewModel!
    var refreshControl: UIRefreshControl!
    var tableFooterView: QuizTableViewFooterView!
    
    var activityIndicator = UIActivityIndicatorView(style: .gray)
    
    convenience init(viewModel: QuizListViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Quiz List"
        setupTableView()
        bindViewModel()
    }
    
    private func setupTableView() {
        let nib = UINib.init(nibName: "QuizTableViewCell", bundle: nil)
        quizTable.register(nib, forCellReuseIdentifier: "QuizTableViewCell")
        quizTable.register(QuizTableHeader.self, forHeaderFooterViewReuseIdentifier: QuizTableHeader.reuseIdentifier)
        
        quizTable.delegate = self
        quizTable.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(QuizListViewController.refresh), for: UIControl.Event.valueChanged)
        quizTable.refreshControl = refreshControl
        
        quizTable.tableFooterView = UIView()
        
        quizTable.backgroundView = activityIndicator
    }
    
    private func bindViewModel() {
        activityIndicator.startAnimating()
        viewModel.fetchQuizList {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.quizTable.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            self.quizTable.reloadData()
            self.refreshControl.endRefreshing()
        }
    }

}

extension QuizListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let quizViewModel = viewModel.quizViewModel(forIndexPath: indexPath)
        let vc = QuizViewController(viewModel: quizViewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(inSection: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: QuizTableHeader.reuseIdentifier) as! QuizTableHeader
        if let headerData = viewModel.quizHeaderData(forSection: section) {
            header.populate(with: headerData)
        }
        return header
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = quizTable.dequeueReusableCell(withIdentifier: "QuizTableViewCell", for: indexPath) as! QuizTableViewCell
        if let quizCellData = viewModel.quizCellData(atIndexPath: indexPath) {
            cell.populate(with: quizCellData)
        }
        return cell
        
    }
}

extension QuizListViewController: TableViewFooterViewDelegate {
    func logoutBtnTapped() {
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "userId")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = LoginViewController()
    }
}
