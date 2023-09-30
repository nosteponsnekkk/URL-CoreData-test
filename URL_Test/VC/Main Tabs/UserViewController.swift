//
//  UserViewController.swift
//  URL_Test
//
//  Created by Олег Наливайко on 11.09.2023.
//

import UIKit

final class UserViewController: UIViewController {
    
    var sectionsArray = [Section]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .primary
        tableView.isScrollEnabled = false
        return tableView
    }()
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 100
        imageView.layer.borderWidth = 5
        imageView.image = UIImage(named: "user.placeholder")
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.backgroundColor = .primary
        
        view.addSubview(imageView)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
      
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.cellID)
        
        makeConstraints()
        setupArray()
        
    }
    
    private func makeConstraints(){
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(200)
            make.top.equalTo(view).offset(50)
            make.centerX.equalTo(view)
        }
        tableView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(imageView.snp_bottomMargin)
            make.height.equalTo(500)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(-75)
        }
    }
    private func setupArray() {
        sectionsArray.append(
            Section(title: "User General", options: [
                SettingRowModel(title: "Change your name", icon: UIImage(named: "user"), bgcolor: .lightLightGray, handler: {}),
                SettingRowModel(title: "Change profile icon", icon: UIImage(named: "image"), bgcolor: .blue, handler: {}),
                SettingRowModel(title: "Change categories", icon: UIImage(named: "filter"), bgcolor: .grayPink, handler: {}),
                SettingRowModel(title: "Change sources", icon: UIImage(named: "document"), bgcolor: .lightGreen, handler: {})
            ]))
        sectionsArray.append(
            Section(title: "Other", options: [
            
                SettingRowModel(title: "About the app", icon: UIImage(named: "info"), bgcolor: .blue, handler: {}),
                SettingRowModel(title: "Log out", icon: UIImage(named: "logout"), bgcolor: .grayPink, handler: {
                    let ac = UIAlertController(title: "Do you want to log out?", message: "Press continue to log out from NewsFeed", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: { [unowned self] _ in
                        AuthenticationManager.shared.logUserOut { isLoggedOut in
                            if isLoggedOut {
                                UIView.transition(with: self.view.window!, duration: 0.3, options: [.transitionCrossDissolve, .showHideTransitionViews], animations: {
                                    self.view.window?.rootViewController = GreetingViewController()
                                }, completion: nil)
                            } else {
                                print("⚠️ Error logging user out")
                            }
                        }
                    }))
                    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    ac.view.tintColor = .primary
                    self.present(ac, animated: true)
                })
               
            ]))
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsArray[section].options.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = sectionsArray[section].title
        return TableViewHeaderView(title: title)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.cellID) as! SettingCell
        let setting = sectionsArray[indexPath.section].options[indexPath.row]
        cell.setContent(title: setting.title, image: setting.icon, color: setting.bgcolor)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let setting = sectionsArray[indexPath.section].options[indexPath.row]
        setting.handler()
    }
}
