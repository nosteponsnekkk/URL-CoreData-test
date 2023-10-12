//
//  CategoryCell.swift
//  URL_Test
//
//  Created by Олег Наливайко on 11.09.2023.
//

import UIKit

class SourceCategoryCell: UICollectionViewCell {
    //MARK: - CELL ID
    public static let cellID = UUID().uuidString
    
    //MARK: - Status
    private var isActive = false
    private var element: CategorySourceModel?
    
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
        setView()
        makeConstraints()
    }
    
    //MARK: - Lifecycle
    override func prepareForReuse() {
            deselect()
    }
    //MARK: - Setting up methods
    
    private func setupCell(){
        
        layer.cornerRadius = 15
        clipsToBounds = true
                
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.01
        
        addSubview(titleLabel)
       
    }
    private func setView(){
        switch isActive {
        case true:
            backgroundColor = .primary
            titleLabel.textColor = .white
        case false:
            backgroundColor = .grayPink
            titleLabel.textColor = .black
        }
    }
    private func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10).priority(.high) 
        }
    }

    
    //MARK: - Interface
    
    public func setAppearance(with element: CategorySourceModel) {
            titleLabel.text = element.title
        self.element = element
        }
    public func isSelected() -> Bool{
        return isActive
    }
    
 
    public func getTitleLabelWidth() -> CGFloat {
    
    return self.titleLabel.intrinsicContentSize.width
}
    public func getElement() -> CategorySourceModel? {
        return element
    }
    public func toggleView(){
        isActive.toggle()
        setView()
    }
    public func deselect() {
        isActive = false
        setView()
    }

}
