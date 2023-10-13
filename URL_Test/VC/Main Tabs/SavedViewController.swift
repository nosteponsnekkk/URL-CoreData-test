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
    private var articles = [Article]() {
        didSet {
            switch articles.isEmpty {
            case true:
                self.clearSavedNewsButton.isEnabled = false
            case false:
                self.clearSavedNewsButton.isEnabled = true
            }
        }
    }
    
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
    private lazy var clearSavedNewsButton: UIButton = {
        let clearSavedNewsButton = UIButton(type: .system)
        clearSavedNewsButton.setImage(UIImage(systemName: "trash"), for: .normal)
        clearSavedNewsButton.tintColor = .white
        clearSavedNewsButton.addTarget(self, action: #selector(clearSavedNews), for: .touchUpInside)
        clearSavedNewsButton.isEnabled = false
        return clearSavedNewsButton
    }()
    
    //MARK: - ViewController Life Cycle
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    init(){
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionViewData), name: Notification.Name("DetailDidRemoveArticle"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionViewData), name: Notification.Name("DetailDidSaveArticle"), object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .primary
        view.addSubview(titleLabel)
        view.addSubview(newsCollectionView)
        view.addSubview(clearSavedNewsButton)
        
        makeConstraints()
        
        newsCollectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.cellID)
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self

        fetchNews()
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("DetailDidRemoveArticle"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("DetailDidSaveArticle"), object: nil)

    }
    
    //MARK: - Other Methods
    private func makeConstraints(){
        
        let margins = view.safeAreaLayoutGuide
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(margins)
            make.top.equalTo(margins).offset(15)
            
        }
        clearSavedNewsButton.snp.makeConstraints { make in
            make.left.top.equalTo(margins).offset(15)
        }
        newsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(15)
            make.right.left.bottom.equalTo(margins)
        }
        
    }
    private func fetchNews(){
        CoreDataManager.shared.fetchAllNews { [unowned self] entities in
            self.articles.removeAll()
            for entity in entities {
                self.articles.append(Article(author: entity.author, title: entity.title, description: entity.descriptionText, publishedAt: entity.timestamp, url: entity.sourceURL, imageData: entity.imageData))
            }
            DispatchQueue.main.async {
                self.newsCollectionView.reloadData()
                self.clearSavedNewsButton.isEnabled = true
            }
        }
    }
    @objc private func clearSavedNews(){
        let ac = UIAlertController(title: "Do you want to remove all saved articles?", message: "Press clear to delete every article", preferredStyle: .alert)
        ac.view.tintColor = .primary
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Clear", style: .default, handler: { [unowned self] _ in
            self.articles.removeAll()
            CoreDataManager.shared.deleteAllNews()
            DispatchQueue.main.async {
                self.newsCollectionView.reloadData()
            }
        }))
        present(ac, animated: true)
    }
    @objc private func reloadCollectionViewData() {
        self.clearSavedNewsButton.isEnabled = false
        fetchNews()
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
            let article = articles[indexPath.item]
        let vc = DetailViewController(article: article)
        navigationController?.pushViewController(vc, animated: true)
        }

    }
