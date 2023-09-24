//
//  StorageManager.swift
//  URL_Test
//
//  Created by Олег Наливайко on 17.09.2023.
//
import Foundation
import CoreData

public final class CoreDataManager {
    // Singleton
    public static let shared = CoreDataManager()
    private init() {}

    // Reference to the main managed object context
    private lazy var mainContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    // Background managed object context for performing asynchronous operations
    private lazy var backgroundContext: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
    }()

    // Persistent container
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.dataBaseName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()

    // MARK: - CRUD
    
    // Create asynchronously
    public func createNews(title: String?, descriptionText: String?, timestamp: String?, sourceURL: String?, author: String?, imageData: Data?, htmlData: String?) {
        backgroundContext.perform {
            guard let newsEntityDescription = NSEntityDescription.entity(forEntityName: Constants.newsEntityName, in: self.backgroundContext) else {
                print("⚠️ CoreData Error: Couldn't create entity: newsEntity")
                return
            }
            let newsEntity = NewsCDEntity(entity: newsEntityDescription, insertInto: self.backgroundContext)
            newsEntity.title = title
            newsEntity.descriptionText = descriptionText
            newsEntity.timestamp = timestamp
            newsEntity.sourceURL = sourceURL
            newsEntity.author = author
            newsEntity.imageData = imageData
            newsEntity.htmlData = htmlData

            self.saveBackgroundContext()
        }
    }

    // Fetch asynchronously
    public func fetchAllNews(completion: @escaping ([NewsCDEntity]) -> Void) {
        backgroundContext.perform {
            let fetchRequest = NSFetchRequest<NewsCDEntity>(entityName: Constants.newsEntityName)
            do {
                let news = try self.backgroundContext.fetch(fetchRequest)
                DispatchQueue.main.async {
                    completion(news)
                }
            } catch {
                print("⚠️ CoreData Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    public func fetchHTMLData(url: String, completion: @escaping (String?) -> Void){
        backgroundContext.perform {
            let fetchRequest = NSFetchRequest<NewsCDEntity>(entityName: Constants.newsEntityName)
            do {
                 let result = try self.backgroundContext.fetch(fetchRequest)
                   if let article = result.first(where: { $0.sourceURL == url }) {
                    DispatchQueue.main.async {
                        completion(article.htmlData)
                    }
                } else {
                    completion(nil)
                }
            } catch  {
                print("⚠️ CoreData Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

    // Update asynchronously
    public func updateNews(title: String?, descriptionText: String?, timestamp: String?, sourceURL: String?, author: String?) {
        backgroundContext.perform {
            let fetchRequest = NSFetchRequest<NewsCDEntity>(entityName: Constants.newsEntityName)
            do {
                if let updatedNews = try self.backgroundContext.fetch(fetchRequest).first(where: { $0.title == title }) {
                    updatedNews.title = title
                    updatedNews.descriptionText = descriptionText
                    updatedNews.timestamp = timestamp
                    updatedNews.sourceURL = sourceURL
                    updatedNews.author = author
                    self.saveBackgroundContext()
                }
            } catch {
                print("⚠️ CoreData Error: \(error.localizedDescription)")
            }
        }
    }

    // Delete asynchronously
    public func deleteAllNews() {
        backgroundContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.newsEntityName)
            do {
                if let result = try self.backgroundContext.fetch(fetchRequest) as? [NewsCDEntity] {
                    result.forEach { self.backgroundContext.delete($0) }
                    self.saveBackgroundContext()
                }
            } catch {
                print("⚠️ CoreData Error: \(error.localizedDescription)")
            }
        }
    }
    public func deleteNewsByTitle(_ title: String) {
        backgroundContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.newsEntityName)
            do {
                if let result = try self.backgroundContext.fetch(fetchRequest) as? [NewsCDEntity],
                    let news = result.first(where: { $0.title == title }) {
                    self.backgroundContext.delete(news)
                    self.saveBackgroundContext()
                }
            } catch {
                print("⚠️ CoreData Error: \(error.localizedDescription)")
            }
        }
    }

    // Save changes on the background context and propagate to the main context
    private func saveBackgroundContext() {
        do {
            try backgroundContext.save()
            mainContext.performAndWait {
                do {
                    try mainContext.save()
                } catch {
                    print("⚠️ CoreData Error: \(error.localizedDescription)")
                }
            }
        } catch {
            print("⚠️ CoreData Error: \(error.localizedDescription)")
        }
    }

    //MARK: - Other methods
    public func checkIsArticleSaved(_ title: String, completion: @escaping (Bool) -> Void) {
        backgroundContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.newsEntityName)
            
            do {
                if let result = try self.backgroundContext.fetch(fetchRequest) as? [NewsCDEntity],
                  result.first(where: { $0.title == title }) != nil {
                    completion(true)
                } else {
                    completion(false)
                }
            } catch  {
                print("⚠️ CoreData Error: \(error.localizedDescription)")
            }
            
        }
    }
    
    // MARK: - Constants
    public struct Constants {
        static let dataBaseName = "NewsFeedCoreData"
        static let newsEntityName = "NewsCDEntity"
    }
}

