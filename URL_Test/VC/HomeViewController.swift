//
//  HomeViewController.swift
//  URL_Test
//
//  Created by Олег Наливайко on 10.09.2023.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    //MARK: UI Elements
    
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
    lazy private var viewAllButton: UIButton = {
        let viewAllButton = UIButton(type: .system)
        viewAllButton.setTitle("View all", for: .normal)
        viewAllButton.tintColor = .lightGray
        viewAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        return viewAllButton
    }()
    lazy private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return collectionView
    }()
    

    //MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.primary
        
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(welcomeLabel)
        view.addSubview(discoverLabel)
        
        view.addSubview(searchTextField)
        view.addSubview(breakingNewsLabel)
        view.addSubview(viewAllButton)
        
        view.addSubview(bottomColor)
        view.addSubview(collectionView)
        
        makeConstraints()
        
        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.cellID)
        collectionView.delegate = self
        collectionView.dataSource = self
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
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(30)
            make.left.equalTo(logoImageView)
        }
        
        discoverLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(5)
            make.left.equalTo(welcomeLabel)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(discoverLabel.snp.bottom).offset(10)
            make.left.equalTo(discoverLabel)
            make.right.equalTo(margins).offset(-20)
            make.height.equalTo(searchTextField.snp.width).dividedBy(7)
        }
        
        breakingNewsLabel.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(30)
            make.left.equalTo(searchTextField)
        }
        
        viewAllButton.snp.makeConstraints { make in
            make.centerY.equalTo(breakingNewsLabel)
            make.right.equalTo(searchTextField)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.top.equalTo(viewAllButton.snp_bottomMargin).offset(15)
            make.height.equalTo(350)
        }
        
        bottomColor.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(view)
            make.height.equalTo(view).dividedBy(2)
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


// MARK: CollectionView methods

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.cellID, for: indexPath) as! NewsCell
        cell.setContent(imageURL: "https://a.fsdn.com/sd/topics/bitcoin_64.png", title: "First Bitcoin ETF Could Be Coming Soon as Court Rules in Favor of Grayscale Over SEC", timeStamp: "2023-08-29T19:20:00Z", author: "Google News")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.height - 20 , height: collectionView.bounds.height)
    }

}
