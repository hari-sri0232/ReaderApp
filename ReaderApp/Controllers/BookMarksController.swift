//
//  BookMarksController.swift
//  ReaderApp
//
//  Created by  HBK on 15/07/25.
//

import UIKit
import CoreData

class BookMarksController: UIViewController {

    @IBOutlet weak var bookmarksTableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    private let viewModel = ArticlesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
        addRefresh()
        setupBindings()
        loadBookmarks()
    }
    
    func registerCells() {
        bookmarksTableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
    }
    
    func loadBookmarks() {
        Task {
           let _ = try? await viewModel.fetchBookMarkedArticles()
        }
    }
    
    func addRefresh() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        bookmarksTableView.refreshControl = refreshControl
    }
    
    private func setupBindings() {
        viewModel.onArticlesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.bookmarksTableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
        viewModel.onError = { errorMessage in
            DispatchQueue.main.async {
                // Simple alert for errors
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(.init(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
}

extension BookMarksController {
    @objc func refreshData() {
        loadBookmarks()
    }
}

extension BookMarksController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bookMarkedarticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        let article = viewModel.bookMarkedarticles[indexPath.row]
        cell.setupCellData(article)
        cell.bookmarkButton.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
