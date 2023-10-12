//
//  OnboardingViewController.swift
//  URL_Test
//
//  Created by Олег Наливайко on 26.09.2023.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    //MARK: - UI Elements
    private lazy var signInTitleLabel: UILabel = {
        let signInTitleLabel = UILabel()
        
        signInTitleLabel.numberOfLines = 2
        
        let text = "Sign In\nEnter your email to sign in NewsFeed app"
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([
            .font: UIFont.boldSystemFont(ofSize: 28),
            .foregroundColor: UIColor.black
        ], range: NSRange(location: 0, length: 8))
        attributedString.addAttributes([
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.black
        ], range: NSRange(location: 8, length: text.count - 8))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.alignment = .center
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: text.count))
        
        signInTitleLabel.attributedText = attributedString

        
        return signInTitleLabel
    }()
    private lazy var emailField: UserCreditsTextfield = {
        let emailField = UserCreditsTextfield(credentials: .email)
        return emailField
    }()
    private lazy var passwordField: UserCreditsTextfield = {
        let passwordField = UserCreditsTextfield(credentials: .password)
        return passwordField
    }()
    private lazy var signButton: OnboardingButton = {
        let signButton = OnboardingButton(buttonTitle: "Sign in")
        signButton.addTarget(self, action: #selector(loginEmail), for: .touchUpInside)
        return signButton
    }()
    private lazy var separator: OnboardingSeparator = {
        let separator = OnboardingSeparator(separatorStyle: .double, height: 2)
        return separator
    }()
    private lazy var signInGoogleButton: OnboardingButton = {
        let signInGoogleButton = OnboardingButton(loginWith: .google)
        return signInGoogleButton
    }()
    private lazy var questionRegisterLabel: UILabel = {
        let questionRegisterLabel = UILabel()
        questionRegisterLabel.text = "New to NewsFeed?"
        questionRegisterLabel.font = UIFont.systemFont(ofSize: 18)
        questionRegisterLabel.textColor = .lightGray
        return questionRegisterLabel
    }()
    private lazy var goToRegisterButton: UIButton = {
        let goToRegisterButton = UIButton(type: .system)
        goToRegisterButton.setTitle("Register", for: .normal)
        goToRegisterButton.titleLabel?.textColor = .blue
        goToRegisterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        goToRegisterButton.addTarget(self, action: #selector(goToRegistration), for: .touchUpInside)
        return goToRegisterButton
    }()

    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .sand
        
        view.addSubview(signInTitleLabel)
        
        view.addSubview(emailField)
        view.addSubview(passwordField)
        
        view.addSubview(signButton)
        
        view.addSubview(separator)
        
        //TODO: Add Google sign in!
//        view.addSubview(signInGoogleButton)
        
        view.addSubview(questionRegisterLabel)
        view.addSubview(goToRegisterButton)
        
        makeConstraints()
    }
    
    //MARK: - Methods
    private func makeConstraints(){
        signInTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(75)
            make.left.right.equalTo(view).inset(25)
        }
        emailField.snp.makeConstraints { make in
            make.top.equalTo(signInTitleLabel.snp.bottom).offset(35)
            make.width.equalTo(signInTitleLabel)
            make.height.equalTo(emailField.snp.width).dividedBy(6)
            make.centerX.equalTo(view)
        }
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp_bottomMargin).offset(35)
            make.size.equalTo(emailField)
            make.centerX.equalTo(view)
        }
        signButton.snp.makeConstraints { make in
            make.size.equalTo(passwordField)
            make.centerX.equalTo(view)
            make.top.equalTo(passwordField.snp_bottomMargin).offset(50)
        }
        separator.snp.makeConstraints { make in
            make.size.equalTo(passwordField)
            make.centerX.equalTo(view)
            make.top.equalTo(signButton.snp_bottomMargin).offset(10)
        }
        //TODO: Add Google Sign in!
//        signInGoogleButton.snp.makeConstraints { make in
//            make.top.equalTo(separator.snp_bottomMargin).offset(10)
//            make.size.equalTo(signButton)
//            make.centerX.equalTo(view)
//        }
        questionRegisterLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view).offset(-50)
            make.bottom.equalTo(view).offset(-75)
        }
        goToRegisterButton.snp.makeConstraints { make in
            make.left.equalTo(questionRegisterLabel.snp_rightMargin).offset(15)
            make.centerY.equalTo(questionRegisterLabel)
        }
        
    }
    @objc private func goToRegistration(){
        navigationController?.pushViewController(RegistrationViewController(), animated: true)
    }
    @objc private func loginEmail(){
        
        let controllers = [emailField, passwordField, signButton, signInGoogleButton]
        controllers.forEach({ $0.isEnabled = false })
        
        guard let password = passwordField.text, let email = emailField.text else {return}
        
        AuthenticationManager.shared.loginUser(email: email, password: password) { [unowned self] isLoggedIn, loginError in
            
            if let loginError = loginError {
                self.present(loginError, animated: true)
                controllers.forEach({ $0.isEnabled = true })
                
            } else if isLoggedIn {
                
                self.view.window?.rootViewController = MainTabBarController()
                self.view.window?.makeKeyAndVisible()
            }
        }
        
    }

}
