//
//  CityListViewController.swift
//  WeatherApp
//
//  Created by admin on 02.08.2021.
//

import UIKit
import GooglePlaces

protocol CityListDisplayLogic: AnyObject {

}
// TODO: - refactoring architecture

class CityListViewController: UIViewController, CityListDisplayLogic {
    
    // MARK: - Properties
    
    var viewModel: CityListPresentationLogic?
    
    private let reuseID = "CityListCell"
    
    // Google SDK
    private var placesClient: GMSPlacesClient!
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel?.viewDidDisappear()
    }

    // MARK: - Setups
  
    static func instantiate() -> CityListViewController {
        let storyboard = UIStoryboard(name: "CityList", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "CityList") as! CityListViewController
        return controller
    }
    
    private func setup() {
        view.backgroundColor = .black
        setupTableView()
        
        placesClient = GMSPlacesClient.shared()
    }
    
    private func setupTableView() {
        tableView.register(CityListCell.nib(), forCellReuseIdentifier: reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
    }
    
    @IBAction func goToSearchVC(_ sender: UIBarButtonItem) {
        viewModel?.presentSearchVC()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        guard let numberOfRows = viewModel?.countDailyCells() else { return 8 }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! CityListCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
