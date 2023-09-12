//
//  NewsCell.swift
//  URL_Test
//
//  Created by Олег Наливайко on 10.09.2023.
//

import UIKit

class NewsCell: UICollectionViewCell {
    
    //MARK: - CELL ID
    
    public static let cellID = UUID().uuidString
    
    //MARK: - Subviews
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightLightGray
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        
        return imageView

        }()
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        activityIndicator.style = .large
        
        
        
        return activityIndicator
    }()
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 3
        titleLabel.backgroundColor = .white
        return titleLabel
    }()
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.textColor = .lightGray
        dateLabel.backgroundColor = .white
        dateLabel.font = UIFont.systemFont(ofSize: 18)
        return dateLabel
    }()
    private lazy var authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.textColor = .lightGray
        authorLabel.backgroundColor = .white
        authorLabel.numberOfLines = 1
        authorLabel.font = UIFont.systemFont(ofSize: 18)
        return authorLabel
    }()
                    
    //MARK: - INITS
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        makeConstraints()
    }
    
    //MARK: - Setting up methods
    
    private func setupCell(){
        
        backgroundColor = .white
        layer.cornerRadius = 25
        clipsToBounds = true

        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 15
        layer.shadowOpacity = 0.3
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        
        addSubview(imageView)
        imageView.addSubview(activityIndicator)
        
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(authorLabel)
    }
    private func makeConstraints(){
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self).inset(15)
            make.height.equalTo(imageView.snp.width).dividedBy(1.8)
        }
        activityIndicator.snp.makeConstraints { make in
            make.edges.equalTo(imageView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp_bottomMargin).offset(15)
            make.left.right.equalTo(self).inset(15)
        }
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(15)
            make.bottom.equalTo(self).offset(-30)
            make.width.equalTo(150)
        }
        authorLabel.snp.makeConstraints { make in
            make.right.equalTo(self).offset(-15)
            make.bottom.equalTo(self).offset(-30)
            make.left.greaterThanOrEqualTo(dateLabel.snp_rightMargin).offset(25)
        }
    }
    
    //MARK: - Interface
    
    public func setContent(imageURL: String?, title: String?, timeStamp: String?, author name: String?){
        if let timeStamp = timeStamp {
            dateLabel.text = "🕒 \(Date().timeAgoDisplay(timeStamp: timeStamp))"
            
        }
        
        authorLabel.text = "by \(name ?? "Unknown")"
        
        titleLabel.text = title
        
        DispatchQueue.main.async { [unowned self] in
            if let imageURL = imageURL {
                shared.cacher.urlToImage(url: imageURL) { image in
                    self.imageView.image = image
                    self.imageView.backgroundColor = .white
                    self.activityIndicator.removeFromSuperview()
                }
            } else {
                self.imageView.image = UIImage(named: "noImageFound")
                self.activityIndicator.removeFromSuperview()
            }
        }
        
        
        
    }
    
}
