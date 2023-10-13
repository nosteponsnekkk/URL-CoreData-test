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
    private var newsCount = 0
    
    private var lastContentOffsetY: CGFloat = 0
    
    private var sortingOption: NewsAPIManager.NewsAPISortingParameters = .byDate
    
    private var selectedCategory: CategorySourceModel!
    
    //MARK: - Data
    private var articles = [Article]() {
        didSet {
            if !articles.isEmpty {
                DispatchQueue.main.async { [unowned self] in
                    self.newsCountLabel.text = "Showing \(self.articles.count) results"
                }
            } else {
                DispatchQueue.main.async { [unowned self] in
                    self.newsCountLabel.text = "No articles found for this request"
                }
            }
        }
    }
    private var categories = [CategorySourceModel]() {
        didSet {
            if categories.isEmpty {
                categoriesCollectionView.isHidden = true
                categoriesCollectionView.snp.updateConstraints { update in
                    update.height.equalTo(7.5)
                }
            } else {
                categoriesCollectionView.isHidden = false
                categoriesCollectionView.snp.updateConstraints { update in
                    update.height.equalTo(75)
                }
            }
        }
    }
    
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
    private lazy var newsCountLabel: UILabel = {
        let newsCountLabel = UILabel()
        newsCountLabel.font = UIFont.systemFont(ofSize: 20)
        newsCountLabel.textColor = .lightGray
        newsCountLabel.isHidden = true
        return newsCountLabel
    }()
    
    //MARK: - ViewController Life Cycle
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    init(){
        super.init(nibName: nil, bundle: nil)
           //Checking for search request
           NotificationCenter.default.addObserver(self, selector: #selector(gotSearchNotification), name: Notification.Name("DidSetSearchQuery"), object: nil)

           //Checking for category request
           NotificationCenter.default.addObserver(self, selector: #selector(gotCategoryNotification), name: Notification.Name("DidSetCategoryQuery"), object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .sand
        
        view.addSubview(searchTextField)
        view.addSubview(categoriesCollectionView)
        view.addSubview(newsCountLabel)
        view.addSubview(newsCollectionView)
        
        makeConstraints()
        
        categoriesCollectionView.register(SourceCategoryCell.self, forCellWithReuseIdentifier: SourceCategoryCell.cellID)
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        
        newsCollectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.cellID)
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self
        
        searchTextField.delegate = self
     
        //If no reuests from queries -> getting healines
        if MainTabBarController.main.categoryQuery == nil && MainTabBarController.main.searchQuery == nil {
            getHeadlines()
        }
        
        //Getting categories
        FirestoreManager.shared.getUserCategories { [unowned self] categories in
            self.categories = categories
            DispatchQueue.main.async {
                self.categoriesCollectionView.reloadData()
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("DidSetSearchQuery"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("DidSetCategoryQuery"), object: nil)
    }
    
    //MARK: - Methods
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
            make.height.equalTo(75)
        }
        newsCountLabel.snp.makeConstraints { make in
            make.left.right.equalTo(margins).inset(15)
            make.top.equalTo(categoriesCollectionView.snp_bottomMargin).offset(7.5)
        }
        newsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(newsCountLabel.snp.bottom).offset(7.5)
            make.left.right.bottom.equalTo(view)
        }
        
    }
    private func getHeadlines(){
        newsCountLabel.isHidden = true
        NewsAPIManager.shared.getHeadlineArticles(withPageSize: 100, withPageNumber: 1, sorting: sortingOption) { [unowned self] articles in
            if let articles = articles {
                self.articles = articles
                if articles.count >= 15 {
                    newsCount = 15
                } else {
                    newsCount = articles.count
                }
                DispatchQueue.main.async { [unowned self] in
                    self.newsCollectionView.reloadData()
                    self.newsCountLabel.isHidden = false
                }
            }
        }
    }
    private func searchNews(search: String){
        newsCountLabel.isHidden = true
        if articles.count >= 15 {
            newsCount = 15
        } else {
            newsCount = articles.count
        }
        
        selectedCategory = nil
        for item in self.categoriesCollectionView.allItems() {
            let category = item as! SourceCategoryCell
            category.deselect()
        }
        
        self.categoriesCollectionView.reloadData()

        articles.removeAll()
        newsCollectionView.reloadData()
        let searchRequest = search.lowercased().replacingOccurrences(of: "", with: "-")
        NewsAPIManager.shared.getArticlesWithKeyWord(searchRequest, withPageSize: 100, sorting: sortingOption) { [unowned self] articles in
            if let articles = articles {
                self.articles = articles
                DispatchQueue.main.async { [unowned self] in
                    
                    self.newsCollectionView.reloadData()
                    self.newsCountLabel.isHidden = false
                }
                
            }
        }
    }
    private func getNewsByCategory(category: CategorySourceModel){
        newsCountLabel.isHidden = true
        if articles.count >= 15 {
            newsCount = 15
        } else {
            newsCount = articles.count
        }
        searchTextField.text?.removeAll()

        articles.removeAll()
        newsCollectionView.reloadData()
        
        NewsAPIManager.shared.getArticlesWithCategory(category, withPageSize: 100, sorting: sortingOption)
        { [unowned self] articles in
            if let articles = articles {
                self.articles = articles
                DispatchQueue.main.async { [unowned self] in
                    self.newsCollectionView.reloadData()
                    self.newsCountLabel.isHidden = false

                }
            }
        }
        
    }
    @objc private func gotSearchNotification(){
        if let searchQuery = MainTabBarController.main.searchQuery {
            searchTextField.text = searchQuery
            searchNews(search: searchQuery)
            MainTabBarController.main.clearQuery()
        }
    }
    @objc private func gotCategoryNotification(){
        if let categoryQuery = MainTabBarController.main.categoryQuery{
            getNewsByCategory(category: categoryQuery)
            selectedCategory = categoryQuery
            categoriesCollectionView.reloadData()
            MainTabBarController.main.clearQuery()
       }
    }
}
//MARK: - CollectionView delegates
extension DiscoverViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case newsCollectionView:
            if articles.isEmpty {
                return 0
            }
            return newsCount
        case categoriesCollectionView:
            return categories.count
        default:
            return 0
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case newsCollectionView:
                let article = articles[indexPath.item]
                    let newsCell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.cellID, for: indexPath) as! NewsCell
                newsCell.setStyle(style: .small)
                newsCell.setContent(imageURL: article.urlToImage , title: article.title , timeStamp: article.publishedAt , author: article.source?.name)
                    return newsCell
             
        case categoriesCollectionView:
            let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: SourceCategoryCell.cellID, for: indexPath) as! SourceCategoryCell
            let category = categories[indexPath.item]
            categoryCell.setAppearance(with: category)
            
            if selectedCategory == category {
                categoryCell.toggleView()
                
            }
            
            return categoryCell
        default:
            return UICollectionViewCell()

        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case newsCollectionView:
            return CGSize(width: (collectionView.bounds.width/2) - 10 , height: (collectionView.bounds.width/2) - 10)
        case categoriesCollectionView:
            let category = categories[indexPath.item]
                let cell = SourceCategoryCell()
                cell.setAppearance(with: category)
                let labelWidth = cell.getTitleLabelWidth()
                let cellWidth = labelWidth + 30
                
                return CGSize(width: cellWidth, height: 50)
        default:
            return CGSize()

        }
        
        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case newsCollectionView:
            let article = articles[indexPath.item]
            let vc = DetailViewController(article: article)
            navigationController?.pushViewController(vc, animated: true)
        case categoriesCollectionView:
            let cell = categoriesCollectionView.cellForItem(at: indexPath) as! SourceCategoryCell
            let cells = categoriesCollectionView.allItems() as! [SourceCategoryCell]
            
            let category = categories[indexPath.item]
            
            if cell.isSelected() {
                selectedCategory = nil
                getHeadlines()
                cell.deselect()
            } else {
                getNewsByCategory(category: category)
                selectedCategory = category
                categoriesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                for categoryCell in cells {
                    categoryCell.deselect()
                }
                cell.toggleView()
            }
            
        default:
            break
        }
       

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

                if articles.count > 15 && articles.count - 15 > newsCount {
                    newsCount += 15
                } else {
                    newsCount = articles.count
                }
            
                didLoadMoreNews = false
                newsCollectionView.reloadData()
                
            }
        }
    }

}
