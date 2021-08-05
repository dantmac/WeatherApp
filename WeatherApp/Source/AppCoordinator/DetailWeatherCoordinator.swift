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
    private let detailWeatherViewController = DetailWeatherViewController.instantiate()
    let detailWeatherViewModel = DetailWeatherViewViewModel()
    var parentCoordinator: CityListCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        setup()
        navigationController.pushViewController(detailWeatherViewController, animated: true)
    }
    
    func startModally(from viewController: UIViewController) {
        setup()
        detailWeatherViewController.isModally = true
        viewController.present(detailWeatherViewController, animated: true, completion: nil)
    }
    
    func backToCityListVC() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func dismiss(_ viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
    
    private func setup() {
        detailWeatherViewModel.coordinator = self
        detailWeatherViewModel.viewController = detailWeatherViewController
        detailWeatherViewController.viewModel = detailWeatherViewModel
    }
}
