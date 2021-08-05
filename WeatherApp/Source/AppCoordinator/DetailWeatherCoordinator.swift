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
    
    var parentCoordinator: CityListCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let detailWeatherViewController = DetailWeatherViewController.instantiate()
        let detailWeatherViewModel = DetailWeatherViewViewModel()
        detailWeatherViewModel.coordinator = self
        detailWeatherViewModel.viewController = detailWeatherViewController
        detailWeatherViewController.viewModel = detailWeatherViewModel
        
        navigationController.pushViewController(detailWeatherViewController, animated: true)
    }
    
    func startModally() {
        let detailWeatherViewController = DetailWeatherViewController.instantiate()
        let detailWeatherViewModel = DetailWeatherViewViewModel()
        detailWeatherViewModel.coordinator = self
        detailWeatherViewModel.viewController = detailWeatherViewController
        detailWeatherViewController.viewModel = detailWeatherViewModel
        
        detailWeatherViewController.isModalInPresentation = true
        
        navigationController.present(detailWeatherViewController, animated: true, completion: nil)
    }
    
    func backToCityListVC() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func dismiss() {
        navigationController.dismiss(animated: false, completion: nil)
        parentCoordinator?.startSearchVC()
    }
    
    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}
