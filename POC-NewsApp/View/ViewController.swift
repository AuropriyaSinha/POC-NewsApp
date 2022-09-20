//
//  ViewController.swift
//  POC-NewsApp
//
//  Created by Auropriya Sinha on 20/09/22.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
    //MARK: programmatically created tableview
    private let tableView : UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    
    private var viewModels = [NewsTableViewCellViewModel]()
    private var articles = [Article]()
    private var articleCopy = [Article]()
    private var newsViewModelObj : NewsViewModel?
    private var searchBarController = UISearchController(searchResultsController: nil)
    private var dataAlreadyLoaded : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        self.callToViewModelForUIUpdate() //MARK: call to fetch top stories
        createSearchBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //MARK: creating search bar
    func createSearchBar() {
        navigationItem.searchController = searchBarController
        searchBarController.searchBar.delegate = self
        searchBarController.isAccessibilityElement = true
    }
    
    //MARK: method to populate UI based on value change
    func callToViewModelForUIUpdate() {
        self.newsViewModelObj = NewsViewModel()
        newsViewModelObj?.bindNewsViewModelToController = {
            guard let articles = self.newsViewModelObj?.articles else {fatalError()}
            self.articles = articles
            if self.dataAlreadyLoaded == false {
                self.articleCopy = articles
                self.dataAlreadyLoaded = true
            }
            self.viewModels = articles.compactMap({
                NewsTableViewCellViewModel(title: $0.title, subtitle: $0.description ?? "No Description", imageURL: URL(string: $0.urlToImage ?? ""), publishedAt: $0.publishedAt)
            })
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell : NewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {fatalError()}
        cell.newsViewModel = newsViewModelObj
        cell.representedIdentifier = viewModels[indexPath.row].publishedAt
        cell.configure(with: viewModels[indexPath.row], publishedAt: cell.representedIdentifier)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = self.articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else {return}
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {return}
        print(text)
        self.newsViewModelObj?.searchedNews(query: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.newsViewModelObj?.cancelSearch(bufferArray: articleCopy)
    }
}

