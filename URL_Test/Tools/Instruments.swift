//
//  Instruments.swift
//  URL_Test
//
//  Created by Олег Наливайко on 11.09.2023.
//

import Foundation
import UIKit

//MARK: - Image Cacher Class

public final class imageCacher {
    
    private let cachedImages = NSCache<NSString, UIImage>()
    private var activeTasks = [URL: URLSessionDataTask]()

    public func urlToImage(url string: String, completion: @escaping (UIImage?) -> Void){
        
        // Creating IDs and URLs
        guard let absoluteString = NSURL(string: string)?.absoluteString else {return}
        guard let url = URL(string: string) else {return}
        let imageID = absoluteString as NSString
        

        //Getting image from cache
        
        if let image = getImageFromCache(url: imageID) {
            DispatchQueue.main.async {
                completion(image)
            }
            return
        }
        
        //Canceling the task, if it's already exist
        if let existingTask = activeTasks[url] {
                    existingTask.cancel()
                    activeTasks[url] = nil
                }
        
        
        // Loading and caching the image
        DispatchQueue.global(qos: .userInitiated).async  { [unowned self] in
            
            // Creating URL Task
        let task = URLSession.shared.dataTask(with: url) {  (data, response, error) in
            if error != nil {
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else { completion(nil); return}
            
                //Caching image
                self.cachedImages.setObject(image, forKey: imageID)
            
                DispatchQueue.main.async {
                    completion(image)
                }
            
            }
            
            // Appending task = active tasks
            activeTasks[url] = task
            
            task.resume()
        }
    }
    
    private func getImageFromCache(url: NSString) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    public func clearCache(){
        cachedImages.removeAllObjects()
    }
}

//MARK: - Utility instruments
    
func composedURL(category: String, pageNumber: Int, resultsForPage: Int) -> String {
    let url = "https://newsapi.org/v2/everything?q=\(category)&page=\(pageNumber)&pageSize=\(resultsForPage)&sortBy=publishedAt&sources=bbc-news,google-news,wired,fox-news,cnn&apiKey=\(shared.APIKey)"
    return url
}

//MARK: - Parsers

func parseNewsArticles(url string: String, completion: @escaping ([Article]) -> Void){
    DispatchQueue.global(qos: .userInitiated).async {
    let JSONDecoder = JSONDecoder()
    let URLSession = URLSession(configuration: .default)
        
    guard let url = URL(string: string) else {return}
    let urlRequest = URLRequest(url: url)
                
        URLSession.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("⚠️ URL Request Error:\(error.localizedDescription)")
                return
            } else if let data = data {
                do {
                    let jsonData = try JSONDecoder.decode(News.self, from: data)
                    
                    print("✅ Status:\(jsonData.status)")
                    print("✅ Total Results:\(jsonData.totalResults)")
                    
                    DispatchQueue.main.async {
                        completion(jsonData.articles)
                    }
                } catch  {
                    print("⚠️ Decoding Error:\(error.localizedDescription)")
                }
            }
            
        }.resume()
        
    }
}



