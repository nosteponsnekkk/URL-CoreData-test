//
//  RegistrationViewController.swift
//  URL_Test
//
//  Created by Олег Наливайко on 27.09.2023.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    //MARK: - UI Elements
    private lazy var signInTitleLabel: UILabel = {
        let signInTitleLabel = UILabel()
        
        signInTitleLabel.numberOfLines = 2
        
        let text = "Sign Up\nEnter your email to register to NewsFeed app"
        
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
    private lazy var nameField: UserCreditsTextfield = {
        let nameField = UserCreditsTextfield(credentials: .name)
        return nameField
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
        let signButton = OnboardingButton(buttonTitle: "Sign up")
        signButton.addTarget(self, action: #selector(signUpEmail), for: .touchUpInside)
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

    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .sand
        setUpNavBar()
        
        view.addSubview(signInTitleLabel)
        view.addSubview(nameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signButton)
        view.addSubview(separator)
        view.addSubview(signInGoogleButton)
        
        makeConstraints()
        
     
        
    }
    
    //MARK: - Methods
    private func setUpNavBar(){
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .primary
        
    }
    private func makeConstraints(){
        signInTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(75)
            make.left.right.equalTo(view).inset(25)
        }
        nameField.snp.makeConstraints { make in
            make.top.equalTo(signInTitleLabel.snp.bottom).offset(35)
            make.width.equalTo(signInTitleLabel)
            make.height.equalTo(emailField.snp.width).dividedBy(6)
            make.centerX.equalTo(view)
        }
        emailField.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp_bottomMargin).offset(35)
            make.size.equalTo(nameField)
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
        signInGoogleButton.snp.makeConstraints { make in
            make.top.equalTo(separator.snp_bottomMargin).offset(10)
            make.size.equalTo(signButton)
            make.centerX.equalTo(view)
        }
        
        
    }
    @objc private func signUpEmail(){
        
        let controllers = [nameField, emailField, passwordField, signButton, signInGoogleButton]
        controllers.forEach({ $0.isEnabled = false })
        
        guard let name = nameField.text, let email = emailField.text, let password = passwordField.text else {return}
        
            AuthenticationManager.shared.createUser(name: name, email: email, password: password) { [unowned self] isCreated, errorAlert in

                    if isCreated {
                        self.view.window?.rootViewController = MainTabBarController()
                        self.view.window?.makeKeyAndVisible()
                        
                    } else if let errorAlert = errorAlert {
                        self.present(errorAlert, animated: true)
                        controllers.forEach({ $0.isEnabled = true })
                    }
                }
                
        
        }
}
        
        
