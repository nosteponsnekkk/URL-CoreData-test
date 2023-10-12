//
//  CategorySourcesSelectorViewController.swift
//  URL_Test
//
//  Created by Олег Наливайко on 02.10.2023.
//

import UIKit

class CategorySourcesSelectorViewController: UIViewController {
    
    //MARK: - Tracking the mode of VC
    public enum CSSelectorMode {
        case create
        case update
    }
    private let mode: CSSelectorMode
    
    //MARK: - Properties
    private var categories = [CategorySourceModel]()
    private var sources = [CategorySourceModel]()
    
    //MARK: - Tracking count of selected sources & categories
    private var selectedSources = [CategorySourceModel]() {
        didSet {
            checkCount()
        }
    }
    private var selectedCategories = [CategorySourceModel]() {
        didSet {
            checkCount()
        }
    }
   
    //MARK: - UI Elements
    lazy private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.numberOfLines = 3
        
        let text = "Customize NewsFeed\nSelect at least 1 source and 1 category"
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([
            .font: UIFont.boldSystemFont(ofSize: 28),
            .foregroundColor: UIColor.black
        ], range: NSRange(location: 0, length: 19))
        attributedString.addAttributes([
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.black
        ], range: NSRange(location: 19, length: text.count - 19))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.alignment = .center
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: text.count))
        
        titleLabel.attributedText = attributedString

        
        return titleLabel
    }()
    lazy private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let insets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        categoryCollectionView.contentInset = insets
        categoryCollectionView.showsVerticalScrollIndicator = false
        categoryCollectionView.backgroundColor = .sand
        return categoryCollectionView
    }()
    lazy private var continueButton: OnboardingButton = {
        let continueButton = OnboardingButton(buttonTitle: "Save news parameters")
        continueButton.makeDisabled()
        continueButton.addTarget(self, action: #selector(updateNews), for: .touchUpInside)
        return continueButton
    }()

    //MARK: - ViewController Lifecycle
    required init?(coder: NSCoder) {
        fatalError("Coder hasn't been implemented")
    }
    init(mode: CSSelectorMode){
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .sand
        
        view.addSubview(titleLabel)
        
        view.addSubview(collectionView)
        
        view.addSubview(continueButton)
        
        makeConstraints()
        
        collectionView.register(SourceCategoryCell.self, forCellWithReuseIdentifier: SourceCategoryCell.cellID)
        collectionView.register(CollectionSectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionSectionView.headerID)

        collectionView.delegate = self
        collectionView.dataSource = self
        
        FirestoreManager.shared.getCategories { [unowned self] categories in
            self.categories = categories
        FirestoreManager.shared.getSources { sources in
                self.sources = sources
           
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if mode == .update {
            MainTabBarController.main.hideTabBar()
            setUpNavBar()
            
            FirestoreManager.shared.getUserCategories { [weak self] selectedCategories in
            self?.selectedCategories = selectedCategories
    
            FirestoreManager.shared.getUserSources { selectedSources in
            self?.selectedSources = selectedSources
                
                    }
                }
            
            }
   
        }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + (mode == .create ? 1 : 0)) { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if mode == .update {
            MainTabBarController.main.showTabBar()
            navigationController?.isNavigationBarHidden = true
        }
    }
   
    //MARK: - Methdos
    private func makeConstraints(){
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(75)
            make.left.right.equalTo(view).inset(25)
        }
            collectionView.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp_bottomMargin).offset(10)
                make.left.right.equalTo(view)
                make.bottom.equalTo(view).offset(-150)
       
            }
            continueButton.snp.makeConstraints { make in
                make.top.equalTo(collectionView.snp.bottom).offset(25)
                make.left.right.equalTo(view).inset(25)
                make.height.equalTo(continueButton.snp.width).dividedBy(6)
                make.centerX.equalTo(view)
            }
        
        
            
        
    }
    private func checkCount(){
        if selectedSources.count >= 1 && selectedCategories.count >= 1 {
            continueButton.makeEnabled()
        } else {
            continueButton.makeDisabled()
        }
    }
    @objc private func updateNews(){
        FirestoreManager.shared.setFavoriteCategoriesAndSources(sources: selectedSources,
                                                                categories: selectedCategories,
                                                                mode: mode) { [unowned self] isCompleted in
            if isCompleted {
                switch mode{
                case .create:
                    self.view.window?.rootViewController = MainTabBarController.main
                    self.view.window?.makeKeyAndVisible()
                case .update:
                    self.navigationController?.popViewController(animated: true)
                }
                
            } else {
                self.present(showError(title: "Error occured", message: "Couldn't save updates for NewsFeed"), animated: true)
            }
            
        }
        
    }
    private func setUpNavBar(){
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .primary
        navigationController?.navigationBar.backItem?.backButtonTitle = ""
        
    }

}

//MARK: - CollectionView Delegate
extension CategorySourcesSelectorViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return categories.count
        case 1:
            return sources.count
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SourceCategoryCell.cellID, for: indexPath) as! SourceCategoryCell
       
        switch indexPath.section {
        case 0:
            let category = categories[indexPath.item]
            cell.setAppearance(with: category)
            if let element = cell.getElement() {
                if selectedCategories.contains(element) {
                    cell.toggleView()
                }
            }
            
            return cell
        case 1:
            let source = sources[indexPath.item]
            cell.setAppearance(with: source)
            if let element = cell.getElement() {
                if selectedSources.contains(element) {
                    cell.toggleView()
                }
            }
            return cell
        default:
            return cell
        }
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = SourceCategoryCell()
            
            switch indexPath.section {
            case 0:
                let category = categories[indexPath.item]
                cell.setAppearance(with: category)
            case 1:
                let source = sources[indexPath.item]
                cell.setAppearance(with: source)
            default:
                break
            }
            
            let labelWidth = cell.getTitleLabelWidth()
            return CGSize(width: labelWidth, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionSectionView.headerID, for: indexPath) as! CollectionSectionView
            
            switch indexPath.section {
            case 0:
                headerView.setTitle(title: "Categories")
                return headerView
            case 1:
                headerView.setTitle(title: "Sources")
                return headerView
            default:
                return UICollectionReusableView()

            }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.bounds.width, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SourceCategoryCell
        guard let element = cell.getElement() else {return}
        
        switch element.type {
        case .category:
            if let selectedCategory = categories.first(where: { $0 == cell.getElement() }) {
                
                if !selectedCategories.contains(selectedCategory) {selectedCategories.append(selectedCategory) } else {
                    if let indexToRemove = selectedCategories.firstIndex(of: selectedCategory) {
                        selectedCategories.remove(at: indexToRemove)
                    }
                }
            }
        
        case.source:
            if let selectedSource = sources.first(where: { $0 == cell.getElement() }) {
                
                if !selectedSources.contains(selectedSource) {selectedSources.append(selectedSource) } else {
                    if let indexToRemove = selectedSources.firstIndex(of: selectedSource) {
                        selectedSources.remove(at: indexToRemove)
                    }
                }
            }
        }
        cell.toggleView()
    }
}
