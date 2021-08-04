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
    
    var parentCoordinator: DetailWeatherCoordinator?
    
    
    
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
    
    func startSearchVC() {
        let filter = GMSAutocompleteFilter()
        let fields: GMSPlaceField = [.name, .coordinate]
        filter.type = .city
        autocompleteVC.autocompleteFilter = filter
        autocompleteVC.placeFields = fields
        
        navigationController.present(autocompleteVC, animated: true, completion: nil)
    }
    
    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}

// MARK: - GMSAutocompleteViewControllerDelegate

extension CityListCoordinator: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name ?? "none")")
        print("Place long: \(place.coordinate.longitude.description), lat: \(place.coordinate.latitude.description)")
        
//        navigationController.dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
