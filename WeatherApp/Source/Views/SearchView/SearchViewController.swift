//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by admin on 30.07.2021.
//

import UIKit

protocol SearchViewDisplayLogic: AnyObject {

}

class SearchViewController: UIViewController, SearchViewDisplayLogic {
    
    var viewModel: SearchViewPresentationLogic?
    
    private let reuseID = "SearchViewCell"
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let cities = ["London",
                          "Oslo",
                          "Moscow",
                          "Kharkiv",
                          "Leganes",
                          "Madrid"]

    private var filteredCities = [String]()

    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel?.viewDidDisappear() 
    }
    
    
    
    
    
    
    static func instantiate() -> SearchViewController {
        let storyboard = UIStoryboard(name: "SearchViewController", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
        return controller
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Enter city"
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.setShowsCancelButton(true, animated: false)
        definesPresentationContext = true
    }
    
    private func setupTableView() {
        tableView.register(SearchViewCell.nib(), forCellReuseIdentifier: reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.didCancelSearching()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCities.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! SearchViewCell
        var city: String
       
        if isFiltering {
            city = filteredCities[indexPath.row]
        } else {
            return cell
        }
        cell.cityLabel.text = city
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}

extension SearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearching(searchController.searchBar.text!)
        print(filteredCities)
    }

    private func filterContentForSearching(_ searchText: String) {
        filteredCities = cities.filter { city in
            return city.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}

extension SearchViewController: UISearchBarDelegate {
    
}
