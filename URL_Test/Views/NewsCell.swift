//
//  NewsCell.swift
//  URL_Test
//
//  Created by Олег Наливайко on 10.09.2023.
//

import UIKit

class NewsCell: UICollectionViewCell {
    
    static let cellID = UUID().uuidString
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
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
                    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        makeConstraints()
    }
    
    func setupCell(){
        
        backgroundColor = .white
        layer.cornerRadius = 25
        clipsToBounds = true

        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 25
        layer.shadowOpacity = 0.1
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        
        addSubview(imageView)
        imageView.addSubview(activityIndicator)


    }
    
    func makeConstraints(){
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self).inset(15)
            make.height.equalTo(imageView.snp.width).dividedBy(1.8)
        }
        activityIndicator.snp.makeConstraints { make in
            make.edges.equalTo(imageView)
        }
    }
    
    public func setContent(imageURL: String){
        
        
        DispatchQueue.main.async { [unowned self] in
            urlToImage(url: imageURL) { image in
                self.imageView.image = image
                self.activityIndicator.removeFromSuperview()
            }
        }
        
    }
    
}
