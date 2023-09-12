//
//  Constants.swift
//  URL_Test
//
//  Created by Олег Наливайко on 11.09.2023.
//

import Foundation


struct shared {
    static let APIKey = "a1812f63e3ba42d382d8be653d20d2f4"
    static let cacher = imageCacher()
    static let categoriesArray = [
        CategoryModel(title: "🎨 Art", URLFormattedTitle: "art", type: .art),
        CategoryModel(title: "💸 Business", URLFormattedTitle: "business", type: .business),
        CategoryModel(title: "🖥️ Technology", URLFormattedTitle: "technology", type: .technology),
        CategoryModel(title: "⚽ Sports", URLFormattedTitle: "sports", type: .sports),
        CategoryModel(title: "🏛️ Politics", URLFormattedTitle: "politics", type: .politics),

    ]
}
