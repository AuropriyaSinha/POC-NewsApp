//
//  APIHandler.swift
//  POC-NewsApp
//
//  Created by Auropriya Sinha on 20/09/22.
//

import Foundation

class APIHandler {
    
    var topHeadLinesURL = URL(string:  "https://newsapi.org/v2/top-headlines?country=US&apiKey=eda6154a62744b7bbad849130a7f7b6f")
    var searchURLString = "https://newsapi.org/v2/everything?sortedBy=popularity&apiKey=eda6154a62744b7bbad849130a7f7b6f&q="
    
    //MARK: API call to fetch Top Stories
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = topHeadLinesURL else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles : \(result.articles.count)")
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    //MARK: Method to fetch stories based on search query
    public func search(query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let urlString = searchURLString + query
        guard let url = URL(string: urlString) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles : \(result.articles.count)")
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    //MARK: method to fetch image data
    public func getImage(url : URL, completion : @escaping (Data) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {return}
            completion(data)
        }.resume()
    }
    
}
