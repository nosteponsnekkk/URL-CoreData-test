//
//  SceneDelegate.swift
//  URL_Test
//
//  Created by Олег Наливайко on 10.09.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        if CoreDataManager.shared.doesUserExist() && AuthenticationManager.shared.isUserOnline() {
            window?.rootViewController = MainTabBarController.main
            } else {
                window?.rootViewController = GreetingViewController()
            }
        window?.makeKeyAndVisible()

        
        }
        
        
        


    }

   




