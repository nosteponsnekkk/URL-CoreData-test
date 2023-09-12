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
    
    //MARK: - Enum
    
    enum Style {
        case large
        case small
    }
    
    //MARK: - Subviews
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightLightGray
        imageView.clipsToBounds = true
       
        
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
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 3
        titleLabel.backgroundColor = .white
        return titleLabel
    }()
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.textColor = .lightGray
        dateLabel.backgroundColor = .white
        return dateLabel
    }()
    private lazy var authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.textColor = .lightGray
        authorLabel.backgroundColor = .white
        authorLabel.numberOfLines = 1
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
        layer.cornerRadius = frame.height/12
        imageView.layer.cornerRadius = layer.cornerRadius
        clipsToBounds = true

        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
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
        
            if let imageURL = imageURL {
                shared.cacher.urlToImage(url: imageURL) { image in
                    DispatchQueue.main.async { [unowned self] in
                        self.imageView.image = image
                        self.activityIndicator.removeFromSuperview()
                    }
                    
                }
            } else {
                imageView.image = UIImage(named: "noImageFound")
                activityIndicator.removeFromSuperview()
            }
        
        
        
        
    }
    
    public func setStyle(style: Style) {
        switch style {
        case .large:
            titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
            dateLabel.font = UIFont.systemFont(ofSize: 18)
            authorLabel.font = UIFont.systemFont(ofSize: 18)
            layer.shadowRadius = 15
            layer.shadowOpacity = 0.3
        case .small:
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            dateLabel.font = UIFont.systemFont(ofSize: 14)
            authorLabel.font = UIFont.systemFont(ofSize: 14)
            layer.shadowRadius = 5
            layer.shadowOpacity = 0.1
            authorLabel.removeFromSuperview()
            dateLabel.removeFromSuperview()
            
            imageView.snp.updateConstraints { update in
                update.top.left.right.equalTo(self)
            }
            
        }
        
    }
    
}
