//
//  CategorySourcesSelectorViewController.swift
//  URL_Test
//
//  Created by Олег Наливайко on 02.10.2023.
//

import UIKit

class CategorySourcesSelectorViewController: UIViewController {
    
    //MARK: - UI Elements
    lazy private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.numberOfLines = 3
        
        let text = "Select categories and sources\nFor NewsFeed to show you"
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([
            .font: UIFont.boldSystemFont(ofSize: 28),
            .foregroundColor: UIColor.black
        ], range: NSRange(location: 0, length: 29))
        attributedString.addAttributes([
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.black
        ], range: NSRange(location: 29, length: text.count - 29))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.alignment = .center
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: text.count))
        
        titleLabel.attributedText = attributedString

        
        return titleLabel
    }()
    lazy private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let insets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        categoryCollectionView.contentInset = insets
        categoryCollectionView.showsVerticalScrollIndicator = false
        categoryCollectionView.backgroundColor = .sand
        return categoryCollectionView
    }()

    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .sand
        
        view.addSubview(titleLabel)
        
        view.addSubview(collectionView)
        
        makeConstraints()
        
        collectionView.register(SourceCategoryCell.self, forCellWithReuseIdentifier: SourceCategoryCell.cellID)
        collectionView.register(CollectionSectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionSectionView.headerID)

        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    //MARK: - Methdos
    private func makeConstraints(){
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(75)
            make.left.right.equalTo(view).inset(25)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(25)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view)
        }
        
    }
    
}

//MARK: - CollectionView Delegate
extension CategorySourcesSelectorViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return shared.categoriesArray.count
        case 1:
            return shared.sourcesArray.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SourceCategoryCell.cellID, for: indexPath) as! SourceCategoryCell
       
        switch indexPath.section {
        case 0:
            let category = shared.categoriesArray[indexPath.item]
            cell.setCategoryType(type: category.type)
            return cell
        case 1:
            let source = shared.sourcesArray[indexPath.item]
            cell.setSourceType(type: source.type)
            return cell
        default:
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = SourceCategoryCell()
            
            switch indexPath.section {
            case 0:
                let category = shared.categoriesArray[indexPath.item]
                cell.setCategoryType(type: category.type)
            case 1:
                let source = shared.sourcesArray[indexPath.item]
                cell.setSourceType(type: source.type)
            default:
                break
            }
            
            let labelWidth = cell.getTitleLabelWidth()
            return CGSize(width: labelWidth, height: 50)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SourceCategoryCell
        cell.toggleView()
    }
  
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionSectionView.headerID, for: indexPath) as! CollectionSectionView
            
            switch indexPath.section {
            case 0:
                headerView.setTitle(title: "Categories")
                return headerView
            case 1:
                headerView.setTitle(title: "Sources")
                return headerView
            default:
                return UICollectionReusableView()

            }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.bounds.width, height: 50)
    }

}
