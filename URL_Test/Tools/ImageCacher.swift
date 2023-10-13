//
//  ImageCacher.swift
//  URL_Test
//
//  Created by Олег Наливайко on 07.10.2023.
//

import Foundation
import UIKit

public final class ImageCacher {
    
    public static let cacher = ImageCacher()
    
    private let cachedImages = NSCache<NSString, UIImage>()
    private var activeTasks = [URL: URLSessionDataTask]()

    public func urlToImage(url string: String, completion: @escaping (UIImage?) -> Void){
        
        
        // Creating IDs and URLs
        guard let absoluteString = NSURL(string: string)?.absoluteString else {completion(UIImage(named: "noImageFound"));return}
        
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
                completion(UIImage(named: "noImageFound"));return
            }
            
            guard let data = data, let image = UIImage(data: data) else {completion(UIImage(named: "noImageFound"));return}
            
                //Caching image
            self.cachedImages.setObject(image, forKey: imageID, cost: data.count)
            
                DispatchQueue.main.async {
                    completion(image)
                    return
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
