//
//  NewsInfoController.swift
//  ReaderApp
//
//  Created by  HBK on 15/07/25.
//

import UIKit
import Kingfisher

class NewsInfoController: UIViewController {

    @IBOutlet weak var newsTableview: UITableView!
    
    //MARK: Custom Properties
    let refreshControl = UIRefreshControl()
    private let viewModel = ArticlesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
        addRefresh()
        setupBindings()
        viewModel.loadArticles()
    }
    
    func registerCells() {
        newsTableview.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
    }
    
    func addRefresh() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        newsTableview.refreshControl = refreshControl
    }
}

// MARK: Refresh

extension NewsInfoController {
    
    private func setupBindings() {
        viewModel.onArticlesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.newsTableview.reloadData()
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
    
    @objc func refreshData() {
        viewModel.loadArticles()
    }
}

extension NewsInfoController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        let article = viewModel.articles[indexPath.row]
        cell.setupCellData(article)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension NewsInfoController: MyCellDelegate {
    func btnTapped(cell: ArticleCell) {
        if let indexPath = self.newsTableview.indexPath(for: cell) {
            let article = viewModel.articles[indexPath.row]
            article.isBookmarked = !article.isBookmarked
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let context = appDelegate.persistentContainer.viewContext
            do {
                try context.save()
                viewModel.loadArticles()
            } catch  {
                
            }
        }
    }
}
