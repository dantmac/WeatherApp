//
//  DetailWeatherCoordinator.swift
//  WeatherApp
//
//  Created by admin on 30.07.2021.
//

import UIKit

final class DetailWeatherCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let detailWeatherViewController = DetailWeatherViewController.instantiate()
        let detailWeatherViewModel = DetailWeatherViewViewModel()
        detailWeatherViewModel.coordinator = self
        detailWeatherViewModel.viewController = detailWeatherViewController
        detailWeatherViewController.viewModel = detailWeatherViewModel
        
        navigationController.setViewControllers([detailWeatherViewController], animated: false )
    }
    
    func startSearchVC() {
        let searchViewCoordinator = SearchViewCoordinator(navigationController: navigationController)
        childCoordinators.append(searchViewCoordinator)
        searchViewCoordinator.start()
    }
    
    
}
