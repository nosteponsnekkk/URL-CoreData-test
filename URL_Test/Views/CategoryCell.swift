//
//  CategoryCell.swift
//  URL_Test
//
//  Created by Олег Наливайко on 11.09.2023.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    //MARK: - CELL ID
    
    public static let cellID = UUID().uuidString
    
    //MARK: - Subviews
   
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        return titleLabel
    }()
                    
    //MARK: - INITS
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        makeConstraints()
    }
    
    //MARK: - Setting up methods
    
    private func setupCell(){
        
        backgroundColor = .grayPink
        layer.cornerRadius = 15
        clipsToBounds = true
                
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.1
        
        addSubview(titleLabel)
       
    }
    private func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10).priority(.high) 
        }
    }

    
    
    //MARK: - Interface
    public func setType(type: CategoryModel.Category){
        
        for category in shared.categoriesArray {
            if category.type == type {
                titleLabel.text = category.title
            }
    
        }
    }
    public func getTitleLabelWidth() -> CGFloat {
    return self.titleLabel.intrinsicContentSize.width
}

}
