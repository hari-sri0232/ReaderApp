//
//  Article.swift
//  ReaderApp
//
//  Created by  HBK on 15/07/25.
//

import Foundation

struct ArticlesResponse: Decodable {
    let articles: [Article]
}

struct Article: Decodable {
    
    var title: String?
    var author: String?
    var profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case title, author
        case profileImage = "urlToImage"
    }
}
