//
//  UserViewController.swift
//  URL_Test
//
//  Created by Олег Наливайко on 11.09.2023.
//

import UIKit

final class UserViewController: UIViewController {
    
    //MARK: - Sections
    private var sectionsArray = [Section]()
    
    //MARK: - UI Elements
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

    //MARK: - ViewController Lifecycle
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
        
        getUserImage()
    }
    
    //MARK: - Methods
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
                SettingRowModel(title: "Change your name", icon: UIImage(named: "user"), bgcolor: .lightLightGray, handler: { [unowned self] in
                    let ac = UIAlertController(title: "Cange your name", message: "Enter new name for your profile", preferredStyle: .alert)
                    ac.addTextField { textfield in
                        textfield.placeholder = "Enter your new name"
                    }
                    ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
                        guard let name: String = ac.textFields?[0].text else { return }
                        AuthenticationManager.shared.updateUser(name: name) { isCompleted in
                            if isCompleted {
                                CoreDataManager.shared.updateUser(name: name)
                                NotificationCenter.default.post(name: Notification.Name("UserDidChangeName"), object: nil)
                            } else {
                                self.present(showError(title: "The problem occured", message: "Couldn't change your name. Check your connection and try again"), animated: true)
                            }
                        }
                        
                    }))
                    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    ac.view.tintColor = .primary
                    self.present(ac, animated: true)
                }),
                SettingRowModel(title: "Change profile icon", icon: UIImage(named: "image"), bgcolor: .blue, handler: { [unowned self] in
                    self.pickImage()
                }),
                SettingRowModel(title: "Change categories and sources", icon: UIImage(named: "filter"), bgcolor: .grayPink, handler: { [unowned self] in
                    self.navigationController?.pushViewController(CategorySourcesSelectorViewController(mode: .update), animated: true)
                }),
            ]))
        sectionsArray.append(
            Section(title: "Other", options: [
                SettingRowModel(title: "About the app", icon: UIImage(named: "info"), bgcolor: .lightGreen, handler: { [unowned self] in
                    
                    let ac = UIAlertController(title: "About the app", message: "This app is a pet-project. Made by Oleg Nalyvaiko (nosteponsnekkk). It shows the skills of working with: REST API, CoreData, Firebase, Parsing JSON, SnapKit code Autolayout.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Great!", style: .cancel))
                    ac.view.tintColor = .primary
                    self.present(ac, animated: true)
                    
                }),
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
    private func pickImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    private func getUserImage(){
        CoreDataManager.shared.fetchUserData { userData in
            if let userImage = UIImage(data: userData?.picture ?? Data()) {
                DispatchQueue.main.async { [unowned self] in
                    self.imageView.image = userImage
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

//MARK: - CollectionView Delegate
extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsArray[section].options.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = sectionsArray[section].title
        return TableSectionView(title: title)
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

//MARK: - UIImagePickerController Delegate
extension UserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        if let imageData = image.pngData() {
            CoreDataManager.shared.updateUser(profileImageData: imageData )
        }
        dismiss(animated: true) { [unowned self] in
            self.getUserImage()
        }
    }
    
}
