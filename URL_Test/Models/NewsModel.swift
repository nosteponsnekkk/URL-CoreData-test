//
//  NewsModel.swift
//  URL_Test
//
//  Created by Олег Наливайко on 11.09.2023.
//

import Foundation

// MARK: - News
public struct News: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
public struct Article: Codable {
    let author: String?
    let title, description: String?
    var urlToImage: String? = nil
    let publishedAt: String?
    let url: String?
    
    var content: String? = nil
    var source: Source? = nil
    
    var imageData: Data? = nil
}

// MARK: - Source
public struct Source: Codable {
    let id: String?
    let name: String?
}
