//
//  CityListViewController.swift
//  WeatherApp
//
//  Created by admin on 02.08.2021.
//

import UIKit
import GooglePlaces

protocol CityListDisplayLogic: AnyObject {
    func reloadData()
    func showToastMessage(message: String)
}

class CityListViewController: UIViewController, CityListDisplayLogic {
    
    // MARK: - Keys
    
    private enum Keys {
        static let storyboardName = "CityList"
        static let storyboardID = "CityList"
        static let cellID = "CityListCell"
    }
    
    // MARK: - Properties
    
    var viewModel: CityListPresentationLogic?
    
    private var placesClient: GMSPlacesClient!
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableFooterView: UIView!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        viewModel?.presentCityList()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Setups
    
    static func instantiate() -> CityListViewController {
        let storyboard = UIStoryboard(name: Keys.storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: Keys.storyboardID) as! CityListViewController
        return controller
    }
    
    private func setup() {
        view.backgroundColor = .black
        
        setupTableView()
        placesClient = GMSPlacesClient.shared()
    }
    
    private func setupTableView() {
        tableView.register(CityListCell.nib(), forCellReuseIdentifier: Keys.cellID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = tableFooterView
    }
    
    // MARK: - Display Logic
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showToastMessage(message: String) {
        Toast.show(message: message, controller: self)
    }
    
    // MARK: - IBActions
    
    @IBAction func goToSearchVC(_ sender: UIButton) {
        viewModel?.presentSearchVC()
    }
    
    @IBAction func refreshButton(_ sender: UIButton) {
        viewModel?.updateCityList()
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = viewModel?.countCities() else { return 0 }
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.cellID, for: indexPath) as! CityListCell
        
        guard let cellViewModel = viewModel?.setCityCellModel(for: indexPath) else { return cell }
        
        cell.set(viewModel: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellViewModel = viewModel?.setCityCellModel(for: indexPath) else { return }
        
        viewModel?.presentDetailWeather(cityCellModel: cellViewModel, from: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel?.removeCity(for: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
