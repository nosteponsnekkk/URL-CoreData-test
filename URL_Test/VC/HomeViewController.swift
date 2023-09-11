//
//  HomeViewController.swift
//  URL_Test
//
//  Created by Олег Наливайко on 10.09.2023.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    private var articles = [Article]()
    
    //MARK: UI Elements
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
        welcomeLabel.text = "Welcome back! Oleg 👋"
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
        searchTextField.font = UIFont.systemFont(ofSize: 20)
        searchTextField.attributedPlaceholder = attributedString
        searchTextField.backgroundColor = .transparentWhite
        searchTextField.clipsToBounds = true
        searchTextField.layer.cornerRadius = 15
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
        return viewAllNewsButton
    }()
    lazy private var breakingNewsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return collectionView
    }()
    lazy private var categoriesTitleLabel: UILabel = {
        let categoriesTitleLabel = UILabel()
        categoriesTitleLabel.text = "Category News"
        categoriesTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        categoriesTitleLabel.textColor = .black
        return categoriesTitleLabel
    }()
    lazy private var viewAllCategoriesButton: UIButton = {
        let viewAllCategoriesButton = UIButton(type: .system)
        viewAllCategoriesButton.setTitle("View all", for: .normal)
        viewAllCategoriesButton.tintColor = .lightGray
        viewAllCategoriesButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        return viewAllCategoriesButton
    }()

    

    //MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        contentView.addSubview(viewAllCategoriesButton)
                
        makeConstraints()
        
        breakingNewsCollectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.cellID)
        breakingNewsCollectionView.delegate = self
        breakingNewsCollectionView.dataSource = self
        
        
        DispatchQueue.main.async { [unowned self] in
            parseNewsArticles(url: composedURL(category: "breaking", pageNumber: 1, resultsForPage: 10)) { articles in
                self.articles = articles
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
                    self.breakingNewsCollectionView.snp.updateConstraints { make in
                        make.height.equalTo(350)
                    }
                } completion: { _ in
                    self.breakingNewsCollectionView.reloadData()
                }

            }
        }
        
    }
    
    //MARK: Other methods
    
    
    func makeConstraints(){
        
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
            make.top.equalTo(viewAllNewsButton.snp_bottomMargin).offset(15)
            make.height.equalTo(0)
        }
        
        categoriesTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(breakingNewsCollectionView.snp.bottom).offset(30)
            make.left.equalTo(breakingNewsLabel)
        }
        
        viewAllCategoriesButton.snp.makeConstraints { make in
            make.top.equalTo(breakingNewsCollectionView.snp.bottom).offset(30)
            make.right.equalTo(viewAllNewsButton)
        }
        
        bottomColor.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(contentView)
            make.height.equalTo(contentView).dividedBy(2)
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


// MARK: CollectionView methods

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return articles.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if !articles.isEmpty {
            let article = articles[indexPath.item]
            
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.cellID, for: indexPath) as! NewsCell
                
            cell.setContent(imageURL: article.urlToImage , title: article.title , timeStamp: article.publishedAt , author: article.source?.name )
                return cell
            } else
            {
                return UICollectionViewCell()
                
            }
        
            
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.bounds.height - 20 , height: collectionView.bounds.height)
            
        }
    

}
