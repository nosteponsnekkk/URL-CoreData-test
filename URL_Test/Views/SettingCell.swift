//
//  SettingCell.swift
//  URL_Test
//
//  Created by Олег Наливайко on 30.09.2023.
//

import UIKit

class SettingCell: UITableViewCell {
    
    static let cellID = UUID().uuidString
    
    private lazy var iconContainer: UIView = {
        let iconContainer = UIView()
        iconContainer.clipsToBounds = true
        iconContainer.layer.cornerRadius = 8
        iconContainer.layer.masksToBounds = true
        return iconContainer
    }()
    private lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.clipsToBounds = true
        iconImageView.tintColor = .white
        return iconImageView
    }()
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(label)
        addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)
        contentView.clipsToBounds = true
        backgroundColor = .sand
        accessoryType = .disclosureIndicator
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size: CGFloat = contentView.frame.size.height - 12
        let imageSize = size/1.5
        iconContainer.frame = CGRect(x: 10, y: 6, width: size, height: size)
        iconImageView.frame = CGRect(x: (size - imageSize)/2, y: (size - imageSize)/2, width: imageSize, height: imageSize)
        label.frame = CGRect(
            x: 30 + iconImageView.frame.size.width,
            y: 0,
            width: contentView.frame.size.width - 30 - iconImageView.frame.size.width,
            height: contentView.frame.size.height)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        iconImageView.image = nil
        
    }
    
    public func setContent(title: String, image: UIImage?, color: UIColor){
        iconContainer.backgroundColor = color
        iconImageView.image = image
        label.text = title
    }
}
