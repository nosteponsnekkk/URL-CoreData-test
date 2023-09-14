//
//  DiscoverViewController.swift
//  URL_Test
//
//  Created by Олег Наливайко on 11.09.2023.
//

import UIKit

final class DiscoverViewController: UIViewController {
    
    //MARK: - Util variavbles
    private var didLoadMoreNews = false
    private var newsCount = 15
    private var lastContentOffsetY: CGFloat = 0
    private var searchContex = "news"
    
    //MARK: - Data
    private var articles = [Article]()
    
    //MARK: - Subviews
    private lazy var searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.clipsToBounds = true
        searchTextField.layer.cornerRadius = 15
        searchTextField.placeholder = "Search News"
        return searchTextField
    }()
    private lazy var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let categoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        categoriesCollectionView.showsHorizontalScrollIndicator = false
        categoriesCollectionView.backgroundColor = .clear
        categoriesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .horizontal
        categoriesCollectionView.backgroundColor = .sand
        return categoriesCollectionView
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

        view.backgroundColor = .sand
        
        view.addSubview(searchTextField)
        view.addSubview(categoriesCollectionView)
        view.addSubview(newsCollectionView)
        
        makeConstraints()
        
        categoriesCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.cellID)
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        
        newsCollectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.cellID)
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self
        
        searchTextField.delegate = self
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let searchQuery = (self.tabBarController as? MainTabBarController)?.searchQuery {
            searchTextField.text = searchQuery
            searchNews(search: searchQuery)
        } else {
            parseNewsArticles(url: composedURL(category: searchContex, pageNumber: 1, resultsForPage: newsCount)) { [unowned self] articles in
                self.articles = articles
                DispatchQueue.main.async {
                self.newsCollectionView.reloadData()
                }

            }
        }

    }
    
    //MARK: - Other Methods
    private func makeConstraints(){
        
        let margins = view.safeAreaLayoutGuide
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(margins).offset(30)
            make.left.right.equalTo(view).inset(15)
            make.height.equalTo(searchTextField.snp.width).dividedBy(8)
        }
        
        categoriesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom)
            make.left.right.equalTo(view)
            make.height.equalTo(100)
        }
        
        newsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoriesCollectionView.snp.bottom)
            make.left.right.bottom.equalTo(view)
        }
        
    }
    private func searchNews(search: String){
        searchContex = search
        articles.removeAll()
        newsCollectionView.reloadData()
            parseNewsArticles(url: composedURL(category: searchContex, pageNumber: 1, resultsForPage: newsCount)) { [unowned self] articles  in
                self.articles = articles
                DispatchQueue.main.async {
                    self.newsCollectionView.reloadData()
                }

            }
        }
    
  
}

//MARK: - CollectionView delegates
extension DiscoverViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.newsCollectionView {
            return articles.count
        }
        if collectionView == self.categoriesCollectionView {
            return shared.categoriesArray.count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.newsCollectionView {
            if !articles.isEmpty {
                let article = articles[indexPath.item]
                
                    let newsCell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.cellID, for: indexPath) as! NewsCell
                newsCell.setStyle(style: .small)
                newsCell.setContent(imageURL: article.urlToImage , title: article.title , timeStamp: article.publishedAt , author: article.source?.name)
                    return newsCell
                } else {
                    return UICollectionViewCell()
                }
        }
            
        if collectionView == self.categoriesCollectionView {
            let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.cellID, for: indexPath) as! CategoryCell
            let categoty = shared.categoriesArray[indexPath.item]
            categoryCell.setType(type: categoty.type)
            return categoryCell
        }
        return UICollectionViewCell()

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.newsCollectionView {
            return CGSize(width: (collectionView.bounds.width/2) - 10 , height: (collectionView.bounds.width/2) - 10)
            }
        
        if collectionView == self.categoriesCollectionView {
            return CGSize(width: 200 , height: 50)
        }
        return CGSize()
        }
    

}

//MARK: - Search delegates
extension DiscoverViewController: UISearchTextFieldDelegate, UIScrollViewDelegate {


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            textField.sendActions(for: .editingDidEnd)
            textField.resignFirstResponder()
            
            if let text = textField.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
                if !text.isEmpty{
                searchContex = text
                searchNews(search: text)
                }
            }
        }
        return true
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchTextField.resignFirstResponder()
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height

        if offsetY > contentHeight - screenHeight {
            if !didLoadMoreNews && offsetY > lastContentOffsetY {
                didLoadMoreNews = true
                lastContentOffsetY = offsetY 

                newsCount += 15

                ImageCacher.cacher.clearCache()
                parseNewsArticles(url: composedURL(category: searchContex, pageNumber: 1, resultsForPage: newsCount)) { [unowned self] updatedArticles in
                    self.articles = updatedArticles
                    DispatchQueue.main.async {
                        self.newsCollectionView.reloadData()
                        didLoadMoreNews = false
                    }
                }
            }
        }
    }

}
