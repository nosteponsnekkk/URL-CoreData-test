//
//  SourceCategoryModels.swift
//  URL_Test
//
//  Created by Олег Наливайко on 11.09.2023.
//

import Foundation

public struct CategorySourceModel: Equatable {
    
    enum ParameterType {
        case source
        case category
    }
    
    let title: String
    let urlFormattedTitle: String
    let type: ParameterType
    
}

