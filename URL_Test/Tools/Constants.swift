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
 
    static let sourcesArray = [
        SourceModel(title: "CNN", URLFormattedTitle: "cnn", type: .CNN),
        SourceModel(title: "BBC", URLFormattedTitle: "bbc-news", type: .BBC),
        SourceModel(title: "Google News", URLFormattedTitle: "google-news", type: .GoogleNews),
        SourceModel(title: "Wired", URLFormattedTitle: "wired", type: .Wired),
        SourceModel(title: "Fox News", URLFormattedTitle: "fox-news", type: .FoxNews),
        SourceModel(title: "Business Insider", URLFormattedTitle: "business-insider", type: .BusinessInsider),
        SourceModel(title: "ABC News", URLFormattedTitle: "abc-news", type: .ABCNews),
        SourceModel(title: "Engadget", URLFormattedTitle: "engadget", type: .Engadget),
        SourceModel(title: "The Verge", URLFormattedTitle: "the-verge", type: .TheVerge),
        SourceModel(title: "Ars Technica", URLFormattedTitle: "ars-technica", type: .ArsTechnica),
        SourceModel(title: "Bleacher Sport", URLFormattedTitle: "bleacher-report", type: .BleacherSport),
        SourceModel(title: "TechRadar", URLFormattedTitle: "techradar", type: .TechRadar),
        SourceModel(title: "Time", URLFormattedTitle: "time", type: .Time),
        SourceModel(title: "ViceNews", URLFormattedTitle: "vice-news", type: .ViceNews),
        

        
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
