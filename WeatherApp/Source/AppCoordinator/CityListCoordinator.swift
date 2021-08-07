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
    private let cityListViewController = CityListViewController.instantiate()
    private let cityListViewModel = CityListViewModel()
    private let autocompleteVC = GMSAutocompleteViewController()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        cityListViewModel.coordinator = self
        cityListViewModel.viewController = cityListViewController
        cityListViewController.viewModel = cityListViewModel
        autocompleteVC.delegate = self
        
        navigationController.pushViewController(cityListViewController, animated: true)
    }
    
    func startDetailVC(_ cityCellModel: CityCellModelProtocol) {
        let detailWeatherCoordinator = DetailWeatherCoordinator(navigationController: navigationController)
        detailWeatherCoordinator.parentCoordinator = self
        childCoordinators.append(detailWeatherCoordinator)
        
        detailWeatherCoordinator.pushGeolocation(name: cityCellModel.name,
                                                 long: cityCellModel.long,
                                                 lat: cityCellModel.lat)
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
    
    func addCity(name: String, long: String, lat: String) {
        cityListViewModel.addCity(name: name, long: long, lat: lat)
    }
}

// MARK: - GMSAutocompleteViewControllerDelegate

extension CityListCoordinator: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let detailWeatherCoordinator = DetailWeatherCoordinator(navigationController: navigationController)
        detailWeatherCoordinator.parentCoordinator = self
        detailWeatherCoordinator.pushGeolocation(name: place.name ?? "",
                                             long: String(place.coordinate.longitude),
                                             lat: String(place.coordinate.latitude))
        detailWeatherCoordinator.startModally(from: autocompleteVC)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        autocompleteVC.dismiss(animated: true, completion: nil)
    }
}
