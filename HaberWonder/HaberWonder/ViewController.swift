//
//  ViewController.swift
//  HaberWonder
//
//  Created by Mac on 4.07.2022.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    private var articles = [Article]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else { fatalError()
            
        }
        cell.configure(with: viewModels[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else { return
            
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
        
    }()
    
    private var viewModels = [NewsTableViewCellViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
       title = "HaberWonder🇹🇷"
    

        
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        createSearchBar()
        
        
        APICaller.shared.getTopStories {  [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({ article in
                    NewsTableViewCellViewModel(title: article.title, subtitle: article.description ?? "Açıklama Yok", imageURL: URL(string: article.urlToImage ?? ""), imageData: nil)
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        tableView.backgroundColor = .systemRed
        
    }
    
    private let searchVC = UISearchController(searchResultsController: nil)


    func createSearchBar() {
        
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
        searchVC.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Haberlerde Ara", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])

        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return
            
        }
        APICaller.shared.search(with: text) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title, subtitle: $0.description ?? "Açıklama Yok", imageURL: URL(string: $0.urlToImage!), imageData: nil)
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchVC.searchBar.endEditing(true)
       
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
        }
    }

}

