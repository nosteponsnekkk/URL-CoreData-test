//
//  MainTabBarController.swift
//  URL_Test
//
//  Created by Олег Наливайко on 11.09.2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.clipsToBounds = true
        view.layer.cornerRadius = 3.3/2
        return view
    }()
    private lazy var indicatorWidth: Double = 0.5 * tabBar.bounds.width / CGFloat(tabBar.items?.count ?? 1)
    private var indicatorColor: UIColor = .black

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.addSubview(indicatorView)
        
        generateTabBar()
        setTabBarAppearance()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        moveIndicator()
    }

    // MARK: - Methods
    
    func moveIndicator(at index: Int=0) {
        
        let itemWidth = (tabBar.bounds.width / CGFloat(tabBar.items?.count ?? 1))
        
        let xPosition = (CGFloat(index) * itemWidth) + ((itemWidth / 2) - (indicatorWidth / 2))

        UIView.animate(withDuration: 0.3) { [self] in
            self.indicatorView.frame = CGRect(x: xPosition,
                                              y: -10,
                                              width: self.indicatorWidth,
                                              height: 3.3)
            self.indicatorView.backgroundColor = self.indicatorColor
        }
    }

    func generateTabBar(){
        viewControllers = [generateVC(viewController: HomeViewController(), image: UIImage(named: "home.icon")),
                           generateVC(viewController: DiscoverViewController(), image: UIImage(named: "discover")),
                           generateVC(viewController: SavedViewController(), image: UIImage(named: "saved")),
                           generateVC(viewController: UserViewController(), image: UIImage(named: "profile"))
        ]
    }
    
    func generateVC(viewController: UIViewController, image: UIImage?) -> UIViewController{
        let resizedImage = image?.resize(to: CGSize(width: 30, height: 30))
            viewController.tabBarItem.image = resizedImage
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.isNavigationBarHidden = true
        return navigationController
    }
    
    func setTabBarAppearance(){
        let x: CGFloat = 0
        
        let y: CGFloat = -10
        
        let width = tabBar.bounds.width
        let height = tabBar.bounds.height + 50
        
        
        let rect = CAShapeLayer()
        let bezierPath = UIBezierPath(rect: CGRect(x: x, y: y, width: width, height: height))
                                      
        rect.path = bezierPath.cgPath
        
        tabBar.layer.insertSublayer(rect, at: 0)
        tabBar.itemWidth = width/CGFloat(tabBar.items?.count ?? 0)
        tabBar.itemPositioning = .centered
        
        rect.fillColor = UIColor.sand.cgColor
        
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .lightLightGray
        tabBar.layer.shadowPath = bezierPath.cgPath
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowRadius = 30
        tabBar.layer.shadowOpacity = 0.25
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let items = tabBar.items else { return }
        moveIndicator(at: items.firstIndex(of: item) ?? 0)
        
        UIView.transition(with: view, duration: 0.1, options: .transitionCrossDissolve, animations: {
            }, completion: nil)
    }
    
}


