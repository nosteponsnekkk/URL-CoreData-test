//
//  OnboardingViewController.swift
//  URL_Test
//
//  Created by Олег Наливайко on 26.09.2023.
//

import UIKit

final class GreetingViewController: UIViewController {
    
    //MARK: - UI Elements
    lazy private var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "randomArticles"))
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    lazy private var discoverLabel: UILabel = {
        let discoverLabel = UILabel()
        discoverLabel.backgroundColor = .sand
        discoverLabel.text = "Discover Breaking News! 🔥"
        discoverLabel.textColor = .black
        discoverLabel.font = UIFont.boldSystemFont(ofSize: 24)
        return discoverLabel
    }()
    lazy private var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Made it easy for users to access the latest and most recent news quickly and easily from a single platform."
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .lightGray
        descriptionLabel.font = UIFont.systemFont(ofSize: 20)
        descriptionLabel.textAlignment = .center
        descriptionLabel.backgroundColor = .sand
        return descriptionLabel
    }()
    lazy private var continueButton: OnboardingButton = {
        let continueButton = OnboardingButton(buttonTitle: "Continue")
        continueButton.addTarget(self, action: #selector(goToOnboarding), for: .touchUpInside)
        return continueButton
    }()

    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        view.addSubview(discoverLabel)
        view.addSubview(descriptionLabel)
        
        view.addSubview(continueButton)
        
        view.backgroundColor = .sand
        
        makeConstraints()
    }
    
    //MARK: - Methods
    private func makeConstraints(){
        imageView.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(35)
            make.top.equalTo(view).offset(75)
            make.height.equalTo(imageView.snp.width).multipliedBy(1.33)
        }
        discoverLabel.snp.makeConstraints { make in
            make.left.right.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(15)
            
        }
        descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalTo(discoverLabel)
            make.top.equalTo(discoverLabel.snp.bottom).offset(15)
        }
        continueButton.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(25)
            make.bottom.equalTo(view).offset(-100)
            make.height.equalTo(continueButton.snp.width).dividedBy(6)
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    @objc private func goToOnboarding() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            UIView.transition(with: self.view.window!, duration: 0.3, options: [.transitionCrossDissolve, .showHideTransitionViews], animations: {
                self.view.window?.rootViewController = UINavigationController(rootViewController: OnboardingViewController())
            }, completion: nil)
        }
        
    }
  
}
