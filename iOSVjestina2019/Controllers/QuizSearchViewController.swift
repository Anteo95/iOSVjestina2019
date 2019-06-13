//
//  QuizSearchViewController.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 30/05/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

class QuizSearchViewController: UIViewController {
    @IBOutlet weak var quizTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: QuizListViewModel!
    var refreshControl: UIRefreshControl!
    
    convenience init(viewModel: QuizListViewModel) {
        self.init()
        self.title = "Search"
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        setupTableView()
        searchBar.delegate = self
        searchBar.placeholder = "Search quizzes"
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
    }
    
    private func bindViewModel() {
        viewModel.searchQuizList(keyword: "")
        self.quizTable.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            self.quizTable.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
}

extension QuizSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
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

extension QuizSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchQuizList(keyword: searchText)
        self.quizTable.reloadData()
        self.refreshControl.endRefreshing()
    }
}
