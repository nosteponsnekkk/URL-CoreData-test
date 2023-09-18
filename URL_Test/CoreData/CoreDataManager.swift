//
//  StorageManager.swift
//  URL_Test
//
//  Created by Олег Наливайко on 17.09.2023.
//

import Foundation
import UIKit
import CoreData

//MARK: - CRUD

public final class CoreDataManager: NSObject {
    //Signletone
    public static let shared = CoreDataManager()
    private override init(){}
    
    public func logCoreData(){
        if let url = appDelegate.persistentContainer.persistentStoreCoordinator.persistentStores.first?.url {
            print("✅ CoreData DB URL:\(url.absoluteString)")

        }
    }
    
    //AppDelegate reference
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    //CoreData contex
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    //MARK: - Interfaces
    
    //Create
    public func createNews(title: String?, descriptionText: String?, timestamp: String?, sourceURL: String?, author: String?, imageData: Data?){
        
        guard let newsEntityDescription = NSEntityDescription.entity(forEntityName: CoreDataManager.Constants.newsEntityName, in: context) else {print("⚠️ CoreData Error: Couldn't create entity: newsEntity");return}
        let newsEntity = NewsCDEntity(entity: newsEntityDescription, insertInto: context)
        newsEntity.title = title
        newsEntity.descriptionText = descriptionText
        newsEntity.timestamp = timestamp
        newsEntity.sourceURL = sourceURL
        newsEntity.author = author
        newsEntity.imageData = imageData
        appDelegate.saveContext()
    }
    
    //Read
    public func fetchAllNews() -> [NewsCDEntity] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataManager.Constants.newsEntityName)
        do {
            return try context.fetch(fetchRequest) as! [NewsCDEntity]
        } catch {
            print("⚠️ CoreData Error: \(error.localizedDescription)")
        }
        return []
    }
    public func fetchNews(_ title: String) -> NewsCDEntity?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataManager.Constants.newsEntityName)
        do {
            guard let news = try context.fetch(fetchRequest) as? [NewsCDEntity] else{return nil}
            return news.first(where: {$0.title == title})
        } catch  {
            print("⚠️ CoreData Error: \(error.localizedDescription)")
        }
        return nil
    }
    
    //Update
    public func updateNews(title: String?, descriptionText: String?, timestamp: String?, sourceURL: String?, author: String?){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataManager.Constants.newsEntityName)
        do {
            guard let news = try context.fetch(fetchRequest) as? [NewsCDEntity], let updatedNews = news.first(where: {$0.title == title}) else{return}
            updatedNews.title = title
            updatedNews.descriptionText = descriptionText
            updatedNews.timestamp = timestamp
            updatedNews.sourceURL = sourceURL
            updatedNews.author = author
        } catch  {
            print("⚠️ CoreData Error: \(error.localizedDescription)")
        }
        appDelegate.saveContext()
    }
    
    //Delete
    public func deleteAllNews(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataManager.Constants.newsEntityName)
        do {
            let result = try context.fetch(fetchRequest) as? [NewsCDEntity]
            result?.forEach{ context.delete($0) }
        } catch  {
            print("⚠️ CoreData Error: \(error.localizedDescription)")
        }
        appDelegate.saveContext()
    }
    public func deleteNewsByTitle(_ title: String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataManager.Constants.newsEntityName)
        do {
            guard let result = try context.fetch(fetchRequest) as? [NewsCDEntity],
                  let news = result.first(where: {$0.title == title}) else {return}
            context.delete(news)
        } catch  {
            print("⚠️ CoreData Error: \(error.localizedDescription)")
        }
        appDelegate.saveContext()
    }
    
    //Constants
    public struct Constants {
        static let dataBaseName = "NewsFeedCoreData"
        static let newsEntityName = "NewsCDEntity"
    }

}



