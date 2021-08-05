//
//  CityListCoordinator.swift
//  WeatherApp
//
//  Created by admin on 02.08.2021.
//

import UIKit
import GooglePlaces

final class CityListCoordinator: NSObject, Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    private let autocompleteVC = GMSAutocompleteViewController()
        
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let cityListViewController = CityListViewController.instantiate()
        let cityListViewModel = CityListViewModel()
        cityListViewModel.coordinator = self
        cityListViewModel.viewController = cityListViewController
        cityListViewController.viewModel = cityListViewModel
        autocompleteVC.delegate = self
        
        navigationController.pushViewController(cityListViewController, animated: true)
    }
    
    func startDetailVC() {
        let detailWeatherCoordinator = DetailWeatherCoordinator(navigationController: navigationController)
        detailWeatherCoordinator.parentCoordinator = self
        childCoordinators.append(detailWeatherCoordinator)
        detailWeatherCoordinator.start()
    }
    
    func startSearchVC() {
        let filter = GMSAutocompleteFilter()
        let fields: GMSPlaceField = [.name, .coordinate]
        filter.type = .city
        autocompleteVC.autocompleteFilter = filter
        autocompleteVC.placeFields = fields
        
        navigationController.present(autocompleteVC, animated: true, completion: nil)
    }
    
    func childDidFinish(_ childCoordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { coordinator in
            return childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
}

// MARK: - GMSAutocompleteViewControllerDelegate

extension CityListCoordinator: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let detailWeatherCoordinator = DetailWeatherCoordinator(navigationController: navigationController)
        detailWeatherCoordinator.startModally(from: autocompleteVC)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        autocompleteVC.dismiss(animated: true, completion: nil)
    }
}
