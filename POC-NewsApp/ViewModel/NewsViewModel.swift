//
//  NewsViewModel.swift
//  POC-NewsApp
//
//  Created by Auropriya Sinha on 20/09/22.
//

import Foundation
import UIKit

class NewsViewModel : NSObject {
    
    public var apiHandler : APIHandler?
    var bindNewsViewModelToController : (() -> ()) = {}
    var bindImageToController : (() -> ()) = {}
    //MARK: Property observer to notify whenever there is a change in articles variable
    private (set) var articles : [Article]! {
        didSet {
            self.bindNewsViewModelToController()
        }
    }
    
    override init() {
        super.init()
        apiHandler = APIHandler()
        callToGetNews()
    }
    
    //MARK: API call to fetch top stories
    func callToGetNews() {
        self.apiHandler?.getTopStories(completion: { result in
            switch result {
            case .success(let articles) :
                self.articles = articles
            case .failure(_) :
                fatalError()
            }
        })
    }
    
    //MARK: API call to fetch stories based on search query
    func searchedNews(query : String) {
        self.apiHandler?.search(query: query, completion: { result in
            switch result {
            case .success(let articles) :
                self.articles = articles
            case .failure(_) :
                fatalError()
            }
        })
    }
    
    //MARK: cancel search functionality
    func cancelSearch(bufferArray : [Article]) {
        self.articles = bufferArray
    }
}
