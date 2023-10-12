//
//  HTMLManager.swift
//  URL_Test
//
//  Created by Олег Наливайко on 09.10.2023.
//

import Foundation


public final class HTMLManager {
    
    //Singletone
    public static let shared = HTMLManager()
    private init(){}
        
    //MARK: - Interfaces
    private func isHTTPS(urlString: String) -> Bool {
        if let url = URL(string: urlString) {
            return url.scheme == "https"
        }
        print("⚠️ Fetching HTML Error: The connection is not secure!")
        return false
    }
    public func fetchHTMLContent(forURL urlString: String?, completion: @escaping (String?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let urlString = urlString else {return}
            guard self.isHTTPS(urlString: urlString) else {return}
            if let url = URL(string: urlString) {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        print("⚠️ URL Request Error:\(error.localizedDescription)")
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    } else if let data = data, let htmlContent = String(data: data, encoding: .utf8) {
                        DispatchQueue.main.async {
                            completion(htmlContent)
                        }
                    } else {
                        print("⚠️ URL Request Error: Unable to get HTML-Content")
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                }
                task.resume()
            } else {
                print("⚠️ URL Request Error: Incorrect URL adress")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }

    }
}
