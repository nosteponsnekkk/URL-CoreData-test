//
//  SavedViewController.swift
//  URL_Test
//
//  Created by Олег Наливайко on 11.09.2023.
//

import UIKit

final class SavedViewController: UIViewController {
    
    //MARK: - Util variavbles
    private var didLoadMoreNews = false
    private var newsCount = 15
    private var lastContentOffsetY: CGFloat = 0
    
    //MARK: - Data
    private var articles = [Article]()
    
    //MARK: - Subviews
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Saved News"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        return titleLabel
    }()
    private lazy var newsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        let newsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        newsCollectionView.backgroundColor = .sand
        newsCollectionView.showsHorizontalScrollIndicator = false
        newsCollectionView.backgroundColor = .clear
        newsCollectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 15, right: 5)
        return newsCollectionView
    }()
    
    //MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .primary
        view.addSubview(titleLabel)
        view.addSubview(newsCollectionView)
        
        makeConstraints()
        
        newsCollectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.cellID)
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        castSavedNewsArray()
    }
    
    
    //MARK: - Other Methods
    private func makeConstraints(){
        
        let margins = view.safeAreaLayoutGuide
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(margins)
            make.top.equalTo(margins).offset(15)
            
        }
        newsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(15)
            make.right.left.bottom.equalTo(margins)
        }
        
    }
    private func castSavedNewsArray(){
        let entities = CoreDataManager.shared.fetchAllNews()
        for entity in entities {
            let article = Article(author: entity.author, title: entity.title, description: entity.descriptionText, publishedAt: entity.timestamp, url: entity.sourceURL, imageData: entity.imageData)
            articles.append(article)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}

//MARK: - CollectionView delegates
extension SavedViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return articles.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let article = articles[indexPath.item]
        let newsCell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.cellID, for: indexPath) as! NewsCell
        newsCell.setStyle(style: .small)
        newsCell.setContent(title: article.title , timeStamp: article.publishedAt , author: article.author, imageData: article.imageData)
            return newsCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            return CGSize(width: (collectionView.bounds.width/2) - 10 , height: (collectionView.bounds.width/2) - 10)
    }
      
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let vc = DetailViewController()
            let article = articles[indexPath.item]
        vc.setContent(author: article.author ?? "Unknown", title: article.title ?? "Some title", timeStamp: article.publishedAt, url: article.url ?? "", description: article.description ?? "", imageData: article.imageData)
            present(vc, animated: true)
        }

    }





  