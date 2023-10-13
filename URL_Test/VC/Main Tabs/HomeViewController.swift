//
//  HomeViewController.swift
//  URL_Test
//
//  Created by Олег Наливайко on 10.09.2023.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
        
    //MARK: - Data properties
    private var articles = [Article]()
    private var categories = [CategorySourceModel]() {
        didSet {
            if categories.isEmpty {
                categoriesTitleLabel.isHidden = true
                categoriesCollectionView.isHidden = true
                categoriesCollectionView.snp.updateConstraints { update in
                    update.height.equalTo(7.5)
                }
            } else {
                categoriesCollectionView.isHidden = false
                categoriesTitleLabel.isHidden = false
                categoriesCollectionView.snp.updateConstraints { update in
                    update.height.equalTo(75)
                }
            }
        }
    }
    private var newsPage = 1
    
    //MARK: - UI Elements
    lazy private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    lazy private var contentView: UIView = {
        let contentView = UIView()
        contentView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        return contentView
    }()
    lazy private var logoImageView: UIImageView = {
        let logoImageView = UIImageView(image: UIImage(named: "smallLogo"))
        logoImageView.contentMode = .scaleAspectFill
        return logoImageView
    }()
    lazy private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        let string = "NewsFeed"
        let attributedString = NSMutableAttributedString(string: string)
        
        attributedString.addAttributes(
        [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24)]
        , range: NSRange(location: 0, length: 4))
        attributedString.addAttributes(
        [NSAttributedString.Key.foregroundColor : UIColor.white]
        , range: NSRange(location: 0, length: 4))
        
        attributedString.addAttributes(
        [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24)]
        , range: NSRange(location: 4, length: 4))
        attributedString.addAttributes(
        [NSAttributedString.Key.foregroundColor : UIColor.lightGray]
        , range: NSRange(location: 4, length: 4))
        
        titleLabel.attributedText = attributedString
        
        return titleLabel
    }()
    lazy private var bottomColor: UIView = {
        let bottomColor = UIView()
        bottomColor.backgroundColor = UIColor.sand
        return bottomColor
    }()
    lazy private var welcomeLabel: UILabel = {
        let welcomeLabel = UILabel()
        welcomeLabel.text = "\(String.greetingForTimeOfDay())!👋"
        welcomeLabel.numberOfLines = 1
        welcomeLabel.textColor = UIColor.lightGray
        welcomeLabel.font = UIFont.systemFont(ofSize: 18)
        return welcomeLabel
    }()
    lazy private var discoverLabel: UILabel = {
        let discoverLabel = UILabel()
        discoverLabel.text = "Discover Breaking News"
        discoverLabel.font = UIFont.boldSystemFont(ofSize: 28)
        discoverLabel.textColor = .white
        discoverLabel.numberOfLines = 1
        return discoverLabel
    }()
    lazy private var searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        let string = "Find Breaking News"
        let attributedString = NSAttributedString(string: string, attributes:
        [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        searchTextField.font = UIFont.systemFont(ofSize: 22)
        searchTextField.attributedPlaceholder = attributedString
        searchTextField.backgroundColor = .transparentWhite
        searchTextField.clipsToBounds = true
        searchTextField.layer.cornerRadius = 15
        searchTextField.textColor = .white
        searchTextField.leftView?.tintColor = .lightGray
        return searchTextField
    }()
    lazy private var breakingNewsLabel: UILabel = {
        let breakingNewsLabel = UILabel()
        breakingNewsLabel.text = "Breaking News 🔥"
        breakingNewsLabel.font = UIFont.boldSystemFont(ofSize: 20)
        breakingNewsLabel.textColor = .white
        return breakingNewsLabel
    }()
    lazy private var viewAllNewsButton: UIButton = {
        let viewAllNewsButton = UIButton(type: .system)
        viewAllNewsButton.setTitle("View all", for: .normal)
        viewAllNewsButton.tintColor = .lightGray
        viewAllNewsButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        viewAllNewsButton.addTarget(self, action: #selector(goSeeMoreNews), for: .touchUpInside)
        return viewAllNewsButton
    }()
    lazy private var breakingNewsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 35
        layout.scrollDirection = .horizontal
        let breakingNewsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        breakingNewsCollectionView.showsHorizontalScrollIndicator = false
        breakingNewsCollectionView.backgroundColor = .clear
        breakingNewsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 35)
        return breakingNewsCollectionView
    }()
    lazy private var categoriesTitleLabel: UILabel = {
        let categoriesTitleLabel = UILabel()
        categoriesTitleLabel.text = "Category News"
        categoriesTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        categoriesTitleLabel.textColor = .black
        return categoriesTitleLabel
    }()
    lazy private var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let categoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        categoriesCollectionView.showsHorizontalScrollIndicator = false
        categoriesCollectionView.backgroundColor = .clear
        categoriesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .horizontal
        return categoriesCollectionView
    }()
    lazy private var pullToRefresh: UIRefreshControl = {
        let pullToRefresh = UIRefreshControl()
        pullToRefresh.tintColor = .lightLightGray
        pullToRefresh.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        return pullToRefresh
    }()

    //MARK: - ViewController Lifecycle
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    init(){
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userDidCahngeName), name: Notification.Name("UserDidChangeName"), object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.refreshControl = pullToRefresh
        
        view.backgroundColor = UIColor.primary
        
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(welcomeLabel)
        contentView.addSubview(discoverLabel)
        
        contentView.addSubview(searchTextField)
        
        contentView.addSubview(breakingNewsLabel)
        contentView.addSubview(viewAllNewsButton)
        
        contentView.addSubview(bottomColor)
        
        contentView.addSubview(breakingNewsCollectionView)
        
        contentView.addSubview(categoriesTitleLabel)
        
        contentView.addSubview(categoriesCollectionView)
                        
        makeConstraints()
        
        breakingNewsCollectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.cellID)
        breakingNewsCollectionView.delegate = self
        breakingNewsCollectionView.dataSource = self
        
        categoriesCollectionView.register(SourceCategoryCell.self, forCellWithReuseIdentifier: SourceCategoryCell.cellID)
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        
        searchTextField.delegate = self
        scrollView.delegate = self
        
        NewsAPIManager.shared.getHeadlineArticles { [unowned self] articles in
            if let articles = articles {
                self.articles = articles
                DispatchQueue.main.async {
                    self.breakingNewsCollectionView.reloadData()
                }
            }
        }
        FirestoreManager.shared.getUserCategories { [unowned self] categories in
            self.categories = categories
            DispatchQueue.main.async {
                self.categoriesCollectionView.reloadData()
            }
        }
        CoreDataManager.shared.fetchUserData { [unowned self] user in
            if let user = user {
                DispatchQueue.main.async {
                    self.welcomeLabel.text = "\(String.greetingForTimeOfDay())! \(user.name ?? "Error getting user name")👋"
                }
                
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("UserDidChangeName"), object: nil)
    }
    //MARK: - Other methods
    private func makeConstraints(){
        
        let margins = view.safeAreaLayoutGuide
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(margins).offset(10)
            make.left.equalTo(margins).offset(20)
            make.width.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(logoImageView.snp.right).offset(15)
            make.centerY.equalTo(logoImageView)
        }
        
        scrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(30)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.left.equalTo(logoImageView)
        }
        
        discoverLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(5)
            make.left.equalTo(contentView).offset(20)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(discoverLabel.snp.bottom).offset(30)
            make.left.equalTo(discoverLabel)
            make.right.equalTo(contentView).offset(-20)
            make.height.equalTo(searchTextField.snp.width).dividedBy(7)
        }
        
        breakingNewsLabel.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(30)
            make.left.equalTo(searchTextField)
        }
        
        viewAllNewsButton.snp.makeConstraints { make in
            make.centerY.equalTo(breakingNewsLabel)
            make.right.equalTo(searchTextField)
        }
        
        breakingNewsCollectionView.snp.makeConstraints { make in
            make.left.right.equalTo(contentView)
            make.top.equalTo(viewAllNewsButton.snp_bottomMargin)
            make.height.equalTo(400)
        }
        
        categoriesTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(breakingNewsCollectionView.snp.bottom)
            make.left.equalTo(breakingNewsLabel)
        }
        
        categoriesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoriesTitleLabel.snp_bottomMargin).offset(15)
            make.left.right.equalTo(contentView)
            make.height.equalTo(75)
        }
        
        bottomColor.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(contentView)
            make.height.equalTo(contentView).dividedBy(2)
            
        }
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @objc private func refreshNews(){
        articles.removeAll()
        newsPage += 1
        if newsPage == 5 {
            newsPage = 1
        }
        breakingNewsCollectionView.reloadData()
        
        NewsAPIManager.shared.getHeadlineArticles(withPageNumber: newsPage) { [unowned self] articles in
            if let articles = articles {
                self.articles = articles
                DispatchQueue.main.async {
                    self.breakingNewsCollectionView.reloadData()
                    self.scrollView.refreshControl?.endRefreshing()
                }
            }
            
        }
        
    }
    @objc private func goSeeMoreNews(){
        MainTabBarController.main.switchToTab(1)
    }
    @objc private func userDidCahngeName(){
        CoreDataManager.shared.fetchUserData { userEntity in
            if let userEntity = userEntity {
                DispatchQueue.main.async {
                    self.welcomeLabel.text = "\(String.greetingForTimeOfDay())! \(userEntity.name ?? "Error getting user name")👋"
                }
            }
        }
    }
}
// MARK: - CollectionView extension
extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case breakingNewsCollectionView:
            return articles.count
        case categoriesCollectionView:
            return categories.count
        default:
            return 0
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case breakingNewsCollectionView:
            
            let article = articles[indexPath.item]
                
            let newsCell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.cellID, for: indexPath) as! NewsCell
            newsCell.setStyle(style: .large)
            newsCell.setContent(imageURL: article.urlToImage , title: article.title , timeStamp: article.publishedAt , author: article.source?.name)
            return newsCell
                
        case categoriesCollectionView:
            let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: SourceCategoryCell.cellID, for: indexPath) as! SourceCategoryCell
            let category = categories[indexPath.item]
            categoryCell.setAppearance(with: category)
            return categoryCell
            
        default:
            return UICollectionViewCell()
        }
        
       
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            switch collectionView {
            case breakingNewsCollectionView:
                return CGSize(width: collectionView.bounds.height - 70 , height: collectionView.bounds.height - 50)
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
        case breakingNewsCollectionView:
            let article = articles[indexPath.item]
            let vc = DetailViewController(article: article)
            
            navigationController?.pushViewController(vc, animated: true)
        case categoriesCollectionView:
            categoriesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            MainTabBarController.main.categoryQuery = categories[indexPath.item]
            MainTabBarController.main.switchToTab(1)
            NotificationCenter.default.post(name: Notification.Name("DidSetCategoryQuery"), object: nil)
            
        default:
            break
        }
    
    }
}
//MARK: - Search delegates
extension HomeViewController: UISearchTextFieldDelegate, UIScrollViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            textField.sendActions(for: .editingDidEnd)
            textField.resignFirstResponder()
            if let text = textField.text{
                if !text.isEmpty{
                    MainTabBarController.main.searchQuery = text
                    MainTabBarController.main.switchToTab(1)
                    NotificationCenter.default.post(name: Notification.Name("DidSetSearchQuery"), object: nil)
                }
            }
        }
        return true
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            searchTextField.resignFirstResponder()
    }
}
