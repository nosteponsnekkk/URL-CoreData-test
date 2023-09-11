//
//  NewsModel.swift
//  URL_Test
//
//  Created by Олег Наливайко on 11.09.2023.
//

import Foundation

// MARK: - News
struct News: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let author: String?
    let title, description: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    let source: Source?
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String?
}
