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
        
        navigationController.pushViewController(detailWeatherViewController, animated: false )
    }
    
    func startCityListVC() {
        let cityListCoordinator = CityListCoordinator(navigationController: navigationController)
        cityListCoordinator.parentCoordinator = self
        childCoordinators.append(cityListCoordinator)
        cityListCoordinator.start()
    }
    
    func childDidFinish(_ childCoordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { coordinator in
            return childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
}
