//
//  APICaller.swift
//  HaberWonder
//
//  Created by Mac on 4.07.2022.
//

import Foundation


final class APICaller {
    
    static let shared = APICaller()
    
    struct Constants {
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=tr&apiKey=58dcef43665b40dd8f2269b630789d7f")
        
        static let searchUrlString = "https://newsapi.org/v2/top-headlines?country=tr&apiKey=58dcef43665b40dd8f2269b630789d7f&q="
    }
    
    private init() {}
    
    public func getTopStories(completion: @escaping(Result<[Article], Error>) -> Void) {
        
        guard let url = Constants.topHeadlinesURL else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
        
    }
    
    public func search(with query: String, completion: @escaping(Result<[Article], Error>) -> Void) {
        
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return
            
        }
        let urlString = Constants.searchUrlString + query
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
        
    }
}

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
    
}
