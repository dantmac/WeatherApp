//
//  DetailWeatherCoordinator.swift
//  WeatherApp
//
//  Created by admin on 30.07.2021.
//

import UIKit
import GooglePlaces

final class DetailWeatherCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    private let detailWeatherViewController = DetailWeatherViewController.instantiate()
    private let detailWeatherViewModel = DetailWeatherViewViewModel()
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
    
    func pushGeolocation(name: String, long: String, lat: String) {
        detailWeatherViewModel.setGeolocation(name: name, long: long, lat: lat)
    }
    
    func addCity(name: String, long: String, lat: String) {
        navigationController.dismiss(animated: true, completion: nil)
        parentCoordinator?.addCity(name: name, long: long, lat: lat)
    }
    
    private func setup() {
        detailWeatherViewModel.coordinator = self
        detailWeatherViewModel.viewController = detailWeatherViewController
        detailWeatherViewController.viewModel = detailWeatherViewModel
    }
}
