//
//  AppDelegate.swift
//  URL_Test
//
//  Created by Олег Наливайко on 10.09.2023.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}

    //MARK: - CoreData
    
    lazy public var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: CoreDataManager.Constants.dataBaseName)
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print("⚠️ CoreData Error: \(error.localizedDescription)")
            } else {
                print("✅ CoreData DB URL:\(description.url!.absoluteString)")
            }
            
        }
        return persistentContainer
    }()
    
    public func saveContext(){
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch  {
                fatalError("❌ CoreData Saving Context Error: \(error.localizedDescription)")
            }
        }
    }
}

