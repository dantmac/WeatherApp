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
        tableView.tableFooterView = tableFooterView
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func goToSearchVC(_ sender: UIButton) {
        viewModel?.presentSearchVC()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = viewModel?.countCells() else { return 0 }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! CityListCell
        
        guard let cellViewModel = viewModel?.setCityCellModel(for: indexPath) else { return cell }
        
        cell.setCell(cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellViewModel = viewModel?.setCityCellModel(for: indexPath) else { return }
        viewModel?.presentDetailWeather(cellViewModel, from: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel?.removeCity(for: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    //        viewModel?.moveRowAt(from: sourceIndexPath, to: destinationIndexPath)
    //    }
    //
    //    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    //        return true
    //    }
}
