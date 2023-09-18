//
//  CategoryModel.swift
//  URL_Test
//
//  Created by Олег Наливайко on 11.09.2023.
//

import Foundation

//MARK: - CategoryModel

struct CategoryModel {
    // Enum for choosing categories
    enum Category {
        case business
        case sports
        case art
        case politics
        case technology
    }
    // Properties
    let title: String
    let URLFormattedTitle: String
    let type: Category
    
}



