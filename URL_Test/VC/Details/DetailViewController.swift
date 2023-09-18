//
//  DetailViewController.swift
//  URL_Test
//
//  Created by Олег Наливайко on 15.09.2023.
//

import UIKit

final class DetailViewController: UIViewController {
    
    //MARK: - Data var
    var currentArticle: Article!
    
    //MARK: - UI elements
    lazy private var pullBar: UILabel = {
        let pullBar = UILabel()
        pullBar.clipsToBounds = true
        pullBar.layer.cornerRadius = 2.5
        pullBar.backgroundColor = .lightGray
        return pullBar
    }()
    lazy private var authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.backgroundColor = .sand
        authorLabel.numberOfLines = 2
        return authorLabel
    }()
    lazy private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.backgroundColor = .sand
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = UIColor.black
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    lazy private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    lazy private var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.backgroundColor = .sand
        dateLabel.font = UIFont.systemFont(ofSize: 18)
        dateLabel.textColor = .lightGray
        return dateLabel
    }()
    lazy private var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.backgroundColor = .sand
        descriptionLabel.font = UIFont.systemFont(ofSize: 20)
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    lazy private var sourcePageButton: UIButton = {
        let sourcePageButton = UIButton(type: .system)
        sourcePageButton.backgroundColor = .sand
        sourcePageButton.setTitle("Source page", for: .normal)
        sourcePageButton.tintColor = .primary
        sourcePageButton.clipsToBounds = true
        sourcePageButton.layer.cornerRadius = 15
        sourcePageButton.layer.borderColor = UIColor.primary.cgColor
        sourcePageButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        sourcePageButton.layer.borderWidth = 2
        return sourcePageButton
    }()
    lazy private var saveButton: UIButton = {
        let saveButton = UIButton(type: .system)
        saveButton.setImage(UIImage(named: "saved.light")?.resize(to: CGSize(width: 33, height: 33)), for: .normal)
        saveButton.backgroundColor = .transparentWhite
        saveButton.layer.cornerRadius = 22
        saveButton.tintColor = .black
        saveButton.clipsToBounds = true
        saveButton.addTarget(self, action: #selector(saveNews), for: .touchUpInside)
        saveButton.isEnabled = false
        return saveButton
    }()
    
    //MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(pullBar)
        
        view.backgroundColor = .sand
        view.addSubview(authorLabel)
        view.addSubview(titleLabel)
        view.addSubview(dateLabel)
        view.addSubview(imageView)
        view.addSubview(descriptionLabel)
        view.addSubview(sourcePageButton)
        view.addSubview(saveButton)
        makeConstraints()
    }
    
    //MARK: - Methods
    private func makeConstraints(){
        
        pullBar.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.width.equalTo(100)
            make.height.equalTo(5)
            make.top.equalTo(view).offset(15)
        }
        saveButton.snp.makeConstraints { make in
            make.centerY.equalTo(authorLabel)
            make.height.width.equalTo(44)
            make.right.equalTo(view).offset(-15)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(pullBar.snp_bottomMargin).offset(35)
            make.left.equalTo(view).inset(15)
            make.right.lessThanOrEqualTo(saveButton.snp_leftMargin)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp_bottomMargin).offset(30)
            make.left.right.equalTo(authorLabel)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(20)
            make.left.right.equalTo(titleLabel)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.left.right.equalTo(view).inset(15)
            make.height.equalTo(imageView.snp.width).dividedBy(1.5)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp_bottomMargin).offset(15)
            make.left.right.equalTo(view).inset(15)
            make.bottom.lessThanOrEqualTo(sourcePageButton.snp_topMargin)
        }
        sourcePageButton.snp.makeConstraints { make in
            make.bottom.equalTo(view).offset(-50)
            make.right.left.equalTo(view).inset(100)
            make.height.equalTo(sourcePageButton.snp.width).dividedBy(4)
        }
    }
    @objc private func saveNews(_ sender: UIButton){
        sender.setImage(UIImage(named: "saved")?.resize(to: CGSize(width: 33, height: 33)), for: .normal)
        sender.tintColor = .primary
        CoreDataManager.shared.createNews(title: currentArticle.title, descriptionText: currentArticle.description, timestamp: currentArticle.publishedAt, sourceURL: currentArticle.url, author: currentArticle.author, imageData: currentArticle.imageData)
    }
    
    //MARK: - Interface
    public func setContent(author: String, title: String, timeStamp: String?, url: String?, imageUrl: String? = nil, description: String, imageData: Data? = nil){
        
        let attributedText = NSMutableAttributedString(string: "posted by \(author)")
        attributedText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)], range: NSRange(location: 0, length: 10))
        attributedText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)], range: NSRange(location: 10, length: author.count))
        authorLabel.attributedText = attributedText
        
        titleLabel.text = title
        dateLabel.text = timeStamp?.formattedNewsDate()
        descriptionLabel.text = !description.isEmpty ? description : "To see full description go to the source page"
        if let imageUrl = imageUrl {
            ImageCacher.cacher.urlToImage(url: imageUrl) { [unowned self] image in
                
                self.currentArticle = Article(author: author, title: title, description: !description.isEmpty ? description : "To see full description go to the source page", publishedAt: timeStamp, url: url, imageData: image?.pngData())
                
                DispatchQueue.main.async{
                    self.imageView.image = image
                    saveButton.isEnabled = true
                }
                
            }
        } else if let imageData = imageData {
            DispatchQueue.main.async{ [unowned self] in
                self.imageView.image = UIImage(data: imageData)
                self.saveButton.setImage(UIImage(named: "saved")?.resize(to: CGSize(width: 33, height: 33)), for: .normal)
                self.saveButton.tintColor = .primary
                self.saveButton.isEnabled = true
            }
        }
        
    }
}
