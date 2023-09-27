//
//  UserCreditsTextfield.swift
//  URL_Test
//
//  Created by Олег Наливайко on 26.09.2023.
//

import UIKit

final class UserCreditsTextfield: UITextField {
    
    //MARK: - Enum with modes
    public enum CreditsType {
        case email
        case password
    }
    
    //MARK: - ImageView
    lazy private var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    //MARK: - INITs
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    init(credentials: CreditsType){
        super.init(frame: .zero)
        setupField(credentials)
    }
    
    //MARK: - TextField setter
    private func setupField(_ credentials: CreditsType){
        
        leftViewMode = .always
        leftView = imageView
        leftView?.tintColor = .lightGray
   
        
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 15
        clipsToBounds = true
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 20),
            .foregroundColor : UIColor.lightGray
        ]
        
        switch credentials {
        case .email:
            imageView.image = UIImage(named: "email")?.resize(to: CGSize(width: 33, height: 33))?.withRenderingMode(.alwaysTemplate)
            let text = NSMutableAttributedString(string: "Your email")
            text.addAttributes(attributes, range: NSRange(location: 0, length: text.string.count))
            attributedPlaceholder = text
            
        case .password:
            imageView.image = UIImage(named: "password")?.resize(to: CGSize(width: 33, height: 33))?.withRenderingMode(.alwaysTemplate)
            let text = NSMutableAttributedString(string: "Password")
            text.addAttributes(attributes, range: NSRange(location: 0, length: text.string.count))
            attributedPlaceholder = text
        }
    }
    
    //MARK: - Frames
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        guard let imageLeft = leftView?.frame.width else {return CGRect()}
        let left = imageLeft + 15
        return bounds.inset(by: UIEdgeInsets(top: 0, left: left + 10, bottom: 0, right: 5))
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        guard let imageLeft = leftView?.frame.width else {return CGRect()}
        let left = imageLeft + 15
        return bounds.inset(by: UIEdgeInsets(top: 0, left: left + 10, bottom: 0, right: 5))
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        guard let imageLeft = leftView?.frame.width else {return CGRect()}
        let left = imageLeft + 15
        return bounds.inset(by: UIEdgeInsets(top: 0, left: left + 10, bottom: 0, right: 5))
    }
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let sizeConstant: CGFloat = 33
        return CGRect(x: 15, y: bounds.midY - (sizeConstant/2) , width: sizeConstant, height: sizeConstant)
    }
}
