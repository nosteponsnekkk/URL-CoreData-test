//
//  TableSectionView.swift
//  URL_Test
//
//  Created by Олег Наливайко on 30.09.2023.
//

import UIKit

class TableSectionView: UILabel {

   
    
    init(title: String){
        super.init(frame: .zero)
        self.text = title
        self.textColor = .white
        self.font = UIFont.boldSystemFont(ofSize: 20)
        self.numberOfLines = 1
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
   
}
