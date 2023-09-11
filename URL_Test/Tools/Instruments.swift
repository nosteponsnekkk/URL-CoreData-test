//
//  Instruments.swift
//  URL_Test
//
//  Created by Олег Наливайко on 11.09.2023.
//

import Foundation
import UIKit

//MARK: - Utility instruments

func urlToImage(url string: String, completion: @escaping (UIImage?) -> Void){
    DispatchQueue.global(qos: .userInitiated).async {
        
        guard let url = URL(string: string) else {return}
        
        do {
          let imageData = try Data(contentsOf: url)
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                completion(image)
            }
        } catch  {
            print(error.localizedDescription)
        }
           
    }
    
    
}
func composedURL(category: String, pageNumber: Int, resultsForPage: Int) -> String {
    let url = "https://newsapi.org/v2/everything?q=\(category)&page=\(pageNumber)&pageSize=\(resultsForPage)&sortBy=publishedAt&apiKey=\(shared.APIKey)"
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



