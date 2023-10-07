//
//  CollectionSectionView.swift
//  URL_Test
//
//  Created by Олег Наливайко on 05.10.2023.
//

import UIKit
import SnapKit
class CollectionSectionView: UICollectionReusableView {
    
    public static let headerID = UUID().uuidString
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
    }

    override func layoutSubviews() {
        titleLabel.frame = bounds
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setTitle(title: String) {
        titleLabel.text = title
    }
}
