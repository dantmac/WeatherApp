//
//  SearchViewCoordinator.swift
//  WeatherApp
//
//  Created by admin on 30.07.2021.
//

import UIKit

final class SearchViewCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    
    var parentCoordinator: CityListCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchViewController = SearchViewController.instantiate()
        let searchViewModel = SearchViewModel()
        searchViewModel.coordinator = self
        searchViewModel.viewController = searchViewController
        searchViewController.viewModel = searchViewModel
        
        navigationController.present(searchViewController, animated: true, completion: nil)
    }
    
    func didCancelSearching() {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}
