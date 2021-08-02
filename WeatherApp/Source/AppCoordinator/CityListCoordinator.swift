//
//  CityListCoordinator.swift
//  WeatherApp
//
//  Created by admin on 02.08.2021.
//

import UIKit

final class CityListCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let cityListViewController = CityListViewController.instantiate()
        let cityListViewModel = CityListViewModel()
        cityListViewModel.coordinator = self
        cityListViewController.viewModel = cityListViewModel
        
        navigationController.pushViewController(cityListViewController, animated: true)
    }
    
    func startSearchVC() {
        let searchViewCoordinator = SearchViewCoordinator(navigationController: navigationController)
        childCoordinators.append(searchViewCoordinator)
        searchViewCoordinator.start()
    }
}
