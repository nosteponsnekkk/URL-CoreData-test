//
//  NewsAPIManager.swift
//  URL_Test
//
//  Created by Олег Наливайко on 07.10.2023.
//

import Foundation

public final class NewsAPIManager {
    
    //MARK: - Singletone
    public static let shared = NewsAPIManager()
    private init(){}
    
    //MARK: - Properties
    private let baseURL = "https://newsapi.org/v2/"
    private let apiKey = "a1812f63e3ba42d382d8be653d20d2f4"

    //MARK: - Parameters for search
    public enum NewsAPISortingParameters: String {
        case byDate = "publishedAt"
        case byPopularity = "popularity"
        case byRelevancy = "relevancy"
    }
    public enum NewsAPISearchingParameters: String {
        case title = "title"
        case content = "content"
        case description = "description"
    }
    
    //MARK: - Parsers
    private func parseNewsWithRequest(_ request: URLRequest, completion: @escaping ([Article]?) -> Void) {
        //Setting JSON-Decoder and URL-Session
        let jsonDecoder = JSONDecoder()
        let urlSession = URLSession(configuration: .default)
        
        urlSession.dataTask(with: request) { data, response, error in
            
            //Exit if any error
            if let error = error {
                print("⚠️ URL Request Error:\(error.localizedDescription)")
                completion(nil)
                return
                
            } else if let data = data {
                
                //Entering DOCATH
                do {
                    //Getting News from JSON Data
                    let jsonData = try jsonDecoder.decode(News.self, from: data)
                    
                    //Checking status
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
                    
                        //Passing valid news in completion
                        completion(validNews)
                        return
                    
                } catch  {
                    print("⚠️ Decoding Error:\(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
            }
            
        }.resume()
    }
  
    //MARK: - Interfaces
  
    //MARK: Getting hot news
    public func getHeadlineArticles(withPageSize pageSize: Int = 15,
                                    withPageNumber pageNumber: Int = 1,
                                    sorting sortingParameter: NewsAPISortingParameters = .byDate,
                                    completion: @escaping ([Article]?) -> Void)
    {
        //Building URL Request
        FirestoreManager.shared.getUserSources { [unowned self] sources in
            let urlFormattedSources: String = sources.map { (sourceModel) -> String in
                return sourceModel.urlFormattedTitle
            }.joined(separator: ",")
            
            let urlString = self.baseURL + "top-headlines" + "?page=\(pageNumber)" + "&pageSize=\(pageSize)" + "&language=en" + "&sortBy=\(sortingParameter.rawValue)" + "&sources=\(urlFormattedSources)" + "&apiKey=\(self.apiKey)"
            guard let url = URL(string: urlString) else {print("⚠️ URL Composing Error: Unable to compose URL");completion(nil);return}
            print("✅ Created URL: \(urlString)")
            
            self.parseNewsWithRequest(URLRequest(url: url)) { articles in
                completion(articles)
            }
        }
        
    }
    
    
    //MARK: Searching article by word
    public func getArticlesWithKeyWord(_ keyWord: String,
                                       withPageSize pageSize: Int = 15,
                                       withPageNumber pageNumber: Int = 1,
                                       sorting sortingParameter: NewsAPISortingParameters = .byDate,
                                       searchIn searchParameter: NewsAPISearchingParameters = .title,
                                       completion: @escaping ([Article]?) -> Void)
    {
        //Building URL Request
        FirestoreManager.shared.getUserSources { [unowned self] sources in
            let urlFormattedSources: String = sources.map { (sourceModel) -> String in
                return sourceModel.urlFormattedTitle
            }.joined(separator: ",")
            
            let urlString = self.baseURL + "everything" + "?q=\(keyWord)" + "&searchIn=\(searchParameter.rawValue)" + "&page=\(pageNumber)" + "&pageSize=\(pageSize)"  + "&language=en" + "&sortBy=\(sortingParameter.rawValue)" + "&sources=\(urlFormattedSources)" + "&apiKey=\(self.apiKey)"
            guard let url = URL(string: urlString) else {print("⚠️ URL Composing Error: Unable to compose URL");completion(nil);return}
            print("✅ Created URL: \(urlString)")

            parseNewsWithRequest(URLRequest(url: url)) { articles in
                completion(articles)
            }
        }
        

    }

    
    //MARK: Searching articles by keyword in category
    public func getArticlesWithCategory(_ category: CategorySourceModel,
                                        withPageSize pageSize: Int = 15,
                                        withPageNumber pageNumber: Int = 1,
                                        sorting sortingParameter: NewsAPISortingParameters = .byDate,
                                        completion: @escaping ([Article]?) -> Void)
    {

        //Building URL Request
            
        let urlString = self.baseURL + "top-headlines" + "?page=\(pageNumber)" + "&pageSize=\(pageSize)"  + "&language=en" + "&sortBy=\(sortingParameter.rawValue)" + "&category=\(category.urlFormattedTitle)" + "&apiKey=\(self.apiKey)"
            guard let url = URL(string: urlString) else {print("⚠️ URL Composing Error: Unable to compose URL");completion(nil);return}
            print("✅ Created URL: \(urlString)")
            
            self.parseNewsWithRequest(URLRequest(url: url)) { articles in
                completion(articles)
            }
        

    }

    
    
    
    
    
    
    
    

    
}
