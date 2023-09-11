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
                
        addSubview(titleLabel)
       
    }
    private func makeConstraints(){
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalTo(self).inset(15)
            make.centerY.equalTo(self)
        }
    }
    //MARK: - Interface
    
   public func setCategory(category: String){
        titleLabel.text = category
    
    }
}
