//
//  ArticleViewModelTests.swift
//  ReaderAppUITests
//
//  Created by  HBK on 15/07/25.
//

import XCTest
@testable import ReaderApp

class ArticleViewModelMock: NewsProtocol {

    var articles: [Articles] = []
    
    var bookMarkedarticles: [Articles] = []
    
    func loadArticles() {
        Task {
            do {
                guard let cArticles = try await loadArticlesFromCoreData() else { return }
                self.articles = cArticles
            } catch {
               
            }
        }
    }
    
    func loadArticlesFromCoreData() async throws -> [ReaderApp.Articles]? {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return []
        }
        let mockArticle = Articles(context: context)
        mockArticle.author = "ABC"
        mockArticle.title = "Hello, i am a mock article"
        mockArticle.isBookmarked = false
        return [mockArticle]
    }
    
    func fetchBookMarkedArticles() async {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return
        }
        let mockArticle = Articles(context: context)
        mockArticle.author = "Brad pitt"
        mockArticle.title = "Hello, i am a bookmarked article"
        mockArticle.isBookmarked = true
        self.bookMarkedarticles = [mockArticle]
    }
    
}

@MainActor
final class ArticleViewModelTests: XCTestCase {
    
    var viewModel: NewsProtocol!

    override func setUpWithError() throws {
        viewModel = ArticlesViewModel(news: ArticleViewModelMock()) as? NewsProtocol
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testLoadArticles() {
        viewModel.loadArticles()
        XCTAssertEqual(viewModel.articles.count, 1)
    }
    
    func testLoadArticlesReturnsBookmarkedArticles() async throws {
        await viewModel.fetchBookMarkedArticles()
        XCTAssertEqual(viewModel.bookMarkedarticles.count, 1)
    }

}
