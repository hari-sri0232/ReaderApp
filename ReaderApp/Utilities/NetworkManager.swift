//
//  NetworkManager.swift
//  ReaderApp
//
//  Created by  HBK on 15/07/25.
//

import Foundation
import UIKit

protocol ArticlesProtocol {
    func fetchArticles() async throws -> [Article]
}

actor NetworkManager: ArticlesProtocol {
    
    let baseUrl = "https://newsapi.org/v2/everything?q=india&from=2025-06-15&sortBy=publishedAt&pageSize=100&apiKey=8643ac8ff264413ea43d7d51fe6e3b08"
    
    func fetchArticles() async throws -> [Article] {
        guard let url = URL(string: baseUrl) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let result = try JSONDecoder().decode(ArticlesResponse.self, from: data)
        return result.articles
    }
    
    func saveAndFetchArticles(_ coreDataArticles: [Articles]) async throws {
        do {
            let articles = try await fetchArticles()
            try await saveArticlesToCoreData(articles, cArticles: coreDataArticles)
            print("Saved \(articles.count) articles to Core Data.")
        } catch {
            print("Error: \(error)")
        }
    }

    
    
    func saveArticlesToCoreData(_ articles: [Article], cArticles: [Articles]) async throws {
        let context = try await MainActor.run {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                throw NSError(domain: "AppError", code: 999, userInfo: [NSLocalizedDescriptionKey: "Cannot access AppDelegate"])
            }
            return appDelegate.persistentContainer.viewContext
        }

        for article in articles {
            let a = Articles(context: context)
            a.title = article.title
            a.author = article.author
            a.profileImageUrl = article.profileImage
            a.isBookmarked = false
            
            if let existing = cArticles.first(where: { $0.title == article.title }) { // Not efficient but there is no unique key to compare from response
                a.isBookmarked = existing.isBookmarked
            }
        }

        try context.save()
    }
    
    
}
