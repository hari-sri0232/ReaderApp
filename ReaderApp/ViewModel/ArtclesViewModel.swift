//
//  ArtclesViewModel.swift
//  ReaderApp
//
//  Created by  HBK on 15/07/25.
//

import Foundation
import UIKit
import CoreData

@MainActor
protocol NewsProtocol {
    var articles: [Articles] { get set }
    var bookMarkedarticles: [Articles] { get set }
    func loadArticles()
    func loadArticlesFromCoreData() async throws -> [Articles]?
    func fetchBookMarkedArticles() async
}

@MainActor
class ArticlesViewModel {
        
    private let newsService: NewsProtocol!
    
    private let networkManager = NetworkManager()
    
    var articles: [Articles] = []
    var bookMarkedarticles: [Articles] = []
    
    var onArticlesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    init(news: NewsProtocol? = nil) {
        self.newsService = news
    }
    
    func loadArticles() {
        Task {
            do {
                guard let cArticles = try await loadArticlesFromCoreData() else { return }
                let _ = try await networkManager.saveAndFetchArticles(cArticles)
                
            } catch {
                onError?(error.localizedDescription)
            }
        }
    }
    
    func loadArticlesFromCoreData() async throws -> [Articles]? {
        let context = await MainActor.run {
            (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        }

        guard let context else { return nil }

        let request: NSFetchRequest<Articles> = Articles.fetchRequest()
        do {
            let savedArticles = try context.fetch(request)
            self.articles = savedArticles
            onArticlesUpdated?()
            return savedArticles
        } catch {
            onError?(error.localizedDescription)
            return nil
        }
    }
    
    func fetchBookMarkedArticles() async {
        
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        let request: NSFetchRequest<Articles> = Articles.fetchRequest()
        
        // Predicate to filter only bookmarked articles
        request.predicate = NSPredicate(format: "isBookmarked == %@", NSNumber(value: true))
        
        do {
            let bArticles = try context?.fetch(request) ?? []
            self.bookMarkedarticles = bArticles
            onArticlesUpdated?()
        } catch {
            print("Failed to fetch bookmarked articles: \(error.localizedDescription)")
            onError?(error.localizedDescription)
        }
    }
}
