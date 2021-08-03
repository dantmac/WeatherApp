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
        
        navigationController.pushViewController(cityListViewController, animated: true)
    }
    
    func startSearchVC() {
        let searchViewCoordinator = SearchViewCoordinator(navigationController: navigationController)
        searchViewCoordinator.parentCoordinator = self
        childCoordinators.append(searchViewCoordinator)
        searchViewCoordinator.start()
    }
    
    func childDidFinish(_ childCoordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { coordinator in
            return childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }

    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}
