//
//  CategoryModel.swift
//  URL_Test
//
//  Created by Олег Наливайко on 11.09.2023.
//

import Foundation


struct CategoryModel {
    
    enum Category {
        case business
        case sports
        case art
        case politics
        case technology
    }
    
    let title: String
    let URLFormattedTitle: String
    let type: Category
    
}



