//
//  OnboardingButton.swift
//  URL_Test
//
//  Created by Олег Наливайко on 26.09.2023.
//

import UIKit

class OnboardingButton: UIButton {
    
    //MARK: - Enum for style
    enum SocialMediaType {
        case google
        case apple
    }
    
    //MARK: - Data property
    private let buttonTitle: String
    
    //MARK: - UI element
    private lazy var textTitleLabel: UILabel = {
        let textTitleLabel = UILabel()
        textTitleLabel.text = buttonTitle
        textTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        textTitleLabel.textColor = .white
        textTitleLabel.textAlignment = .center
        return textTitleLabel
    }()
    private lazy var socialImageView: UIImageView = {
        let socialImageView = UIImageView()
        return socialImageView
    }()
    
    //MARK: - INITs
    init(buttonTitle: String = "", loginWith: SocialMediaType? = nil){
        self.buttonTitle = buttonTitle
        super.init(frame: .zero)
        
        if let loginWith = loginWith {
            setupCell()
            setupSocialLoginStyle(type: loginWith)
        } else {
            setupCell()
            backgroundColor = .primary
            makeConstraints()
        }
        
    }
    required init?(coder: NSCoder) {
        buttonTitle = ""
        super.init(coder: coder)
    }
    
    //MARK: - Original transform for animation
    private var originalTransform: CGAffineTransform = .identity
    
    //MARK: - Methods
    private func setupCell(){
        
        layer.shadowPath = UIBezierPath(rect: frame).cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 15
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addTapAnimations()
        
        addSubview(textTitleLabel)
    }
    private func makeConstraints(){
        textTitleLabel.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(self).inset(15)
        }
        
    }
    private func setupSocialLoginStyle(type: SocialMediaType){
        
        addSubview(socialImageView)
        
        switch type {
        case .apple:
            textTitleLabel.text = "Sign in with Apple"
            textTitleLabel.textColor = .white
            socialImageView.image = UIImage(named: "applelogo")?.resize(to: CGSize(width: 22, height: 22))
            backgroundColor = .black
        case .google:
            textTitleLabel.text = "Sign in with Google"
            textTitleLabel.textColor = .black
            socialImageView.image = UIImage(named: "google")?.resize(to: CGSize(width: 22, height: 22))
            backgroundColor = .white
        }
        
        //Making some constraints
        
        textTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.centerX.equalTo(self).offset(15)
        }
        socialImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(textTitleLabel.snp_leftMargin).offset(-15)
        }
        
    }
    
    //MARK: - Interfaces
    public func makeDisabled(){
        isEnabled = false
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.layer.opacity = 0.3
        }
    }
    public func makeEnabled(){
        isEnabled = true
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.layer.opacity = 1
        }
    }

}
