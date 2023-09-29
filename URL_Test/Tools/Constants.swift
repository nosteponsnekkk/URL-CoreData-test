//
//  Constants.swift
//  URL_Test
//
//  Created by Олег Наливайко on 11.09.2023.
//

import Foundation


struct shared {
    static let APIKey = "a1812f63e3ba42d382d8be653d20d2f4"
    static let APIKey2 = "b4d30f911220410c95efcc0c31fbdffa"
    static let categoriesArray = [
        CategoryModel(title: "🎨 Art", URLFormattedTitle: "art", type: .art),
        CategoryModel(title: "💸 Business", URLFormattedTitle: "business", type: .business),
        CategoryModel(title: "🖥️ Technology", URLFormattedTitle: "technology", type: .technology),
        CategoryModel(title: "⚽ Sports", URLFormattedTitle: "sports", type: .sports),
        CategoryModel(title: "🏛️ Politics", URLFormattedTitle: "politics", type: .politics),
    ]
 
    struct sources {
        static let CNN = "cnn"
        static let BBC = "bbc-news"
        static let GoogleNews = "google-news"
        static let Wired = "wired"
        static let FoxNews = "fox-news"
        static let BusinessInsider = "business-insider"
        static let ABCNews = "abc-news"
        static let Engadget = "engadget"
        static let TheVerge = "the-verge"
        static let ArsTechnica = "ars-technica"
        static let BleacherSport = "bleacher-report"
        static let TechRadar = "techradar"
        static let Time = "time"
        static let ViceNews = "vice-news"
    }
  
}
