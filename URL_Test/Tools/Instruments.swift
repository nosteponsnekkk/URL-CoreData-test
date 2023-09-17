//
//  Instruments.swift
//  URL_Test
//
//  Created by Олег Наливайко on 11.09.2023.
//

import Foundation
import UIKit

//MARK: - Image Cacher Class

public final class ImageCacher {
    
    public static let cacher = ImageCacher()
    
    private let cachedImages = NSCache<NSString, UIImage>()
    private var activeTasks = [URL: URLSessionDataTask]()

    public func urlToImage(url string: String, completion: @escaping (UIImage?) -> Void){
        
        // Creating IDs and URLs
        guard let absoluteString = NSURL(string: string)?.absoluteString else {return}
        
        //Checks if the connection is secure
        guard isHTTPS(urlString: absoluteString) else {completion(UIImage(named: "noImageFound"));return}
        
        guard let url = URL(string: string) else {completion(UIImage(named: "noImageFound"));return}
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
        DispatchQueue.main.async  { [unowned self] in
            
            // Creating URL Task
        let task = URLSession.shared.dataTask(with: url) {  (data, response, error) in
            if error != nil {
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else { completion(nil); return}
            
                //Caching image
            self.cachedImages.setObject(image, forKey: imageID, cost: data.count)
            
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
    private func isHTTPS(urlString: String) -> Bool {
        if let url = URL(string: urlString) {
            return url.scheme == "https"
        }
        print("⚠️ URL Making Error: The connection is not secure!")
        return false
    }
    public func clearCache(){
        cachedImages.removeAllObjects()
    }
}

//MARK: - Utility instruments
    
public func composedURL(request: String? = nil, pageNumber: Int? = nil, resultsForPage: Int? = nil, sources: [String]? = nil, country: String? = nil) -> String {
    var url:String
    defer {print("URL Created: \(url)")}
    if let pageNumber = pageNumber, let resultsForPage = resultsForPage {
        if let request = request {
            if let sources = sources {
                let stringSources = sources.joined(separator: ",")
                 url = "https://newsapi.org/v2/everything?q=\(request)&searchIn=title&page=\(pageNumber)&pageSize=\(resultsForPage)&sortBy=publishedAt&sources=\(stringSources)&apiKey=\(shared.APIKey2)"
            return url
            }
            else if let country = country {
                 url = "https://newsapi.org/v2/everything?q=\(request)&searchIn=title&country=\(country)&page=\(pageNumber)&pageSize=\(resultsForPage)&sortBy=publishedAt&&apiKey=\(shared.APIKey2)"
            return url
            }
            else {
                 url = "https://newsapi.org/v2/everything?q=\(request)&searchIn=title&page=\(pageNumber)&pageSize=\(resultsForPage)&sortBy=publishedAt&&apiKey=\(shared.APIKey2)"
            return url
            }
        } else {
            if let sources = sources {
                let stringSources = sources.joined(separator: ",")
                 url = "https://newsapi.org/v2/top-headlines?page=\(pageNumber)&pageSize=\(resultsForPage)&sortBy=publishedAt&sources=\(stringSources)&apiKey=\(shared.APIKey2)"
            return url
            }
            else if let country = country {
                 url = "https://newsapi.org/v2/top-headlines?country=\(country)&page=\(pageNumber)&pageSize=\(resultsForPage)&sortBy=publishedAt&&apiKey=\(shared.APIKey2)"
            return url
            }
            else {
                 url = "https://newsapi.org/v2/top-headlines?language=en&page=\(pageNumber)&pageSize=\(resultsForPage)&sortBy=publishedAt&&apiKey=\(shared.APIKey2)"
            return url
            }
        }
       
    } else {
        if let request = request {
            if let sources = sources {
                let stringSources = sources.joined(separator: ",")
                 url = "https://newsapi.org/v2/everything?q=\(request)&searchIn=title&sortBy=publishedAt&sources=\(stringSources)&apiKey=\(shared.APIKey2)"
            return url
            }
            else if let country = country {
                 url = "https://newsapi.org/v2/everything?q=\(request)&searchIn=title&country=\(country)&sortBy=publishedAt&&apiKey=\(shared.APIKey2)"
            return url
            }
            else {
                 url = "https://newsapi.org/v2/everything?q=\(request)&sortBy=publishedAt&&apiKey=\(shared.APIKey2)"
            return url
            }
        } else {
            if let sources = sources {
                let stringSources = sources.joined(separator: ",")
                 url = "https://newsapi.org/v2/top-headlines?sortBy=publishedAt&sources=\(stringSources)&apiKey=\(shared.APIKey2)"
            return url
            }
            else if let country = country {
                 url = "https://newsapi.org/v2/top-headlines?country=\(country)&sortBy=publishedAt&&apiKey=\(shared.APIKey2)"
            return url
            }
            else {
                 url = "https://newsapi.org/v2/top-headlines?language=en&sortBy=publishedAt&&apiKey=\(shared.APIKey2)"
            return url
            }
        }
    }
    
   
}

//MARK: - Parsers
 internal func parseNewsArticles(url string: String, completion: @escaping ([Article]) -> Void){
    DispatchQueue.global(qos: .userInitiated).async {
    let JSONDecoder = JSONDecoder()
    let URLSession = URLSession(configuration: .default)
        
    guard let url = URL(string: string) else {print("⚠️ URL Composing Error: Unable to compose URL");return}
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
                    
                    //Checks for [Removed] news
                    let validNews = jsonData.articles.filter { article in
                            if article.source?.name != "[Removed]" &&
                               article.title != "[Removed]" &&
                               article.description != "[Removed]" {
                                return true
                            }
                            return false
                        }
                    
                    DispatchQueue.main.async {
                        completion(validNews)
                    }
                } catch  {
                    print("⚠️ Decoding Error:\(error.localizedDescription)")
                }
            }
            
        }.resume()
        
    }
}



