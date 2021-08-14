//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by admin on 30.07.2021.
//

import UIKit
import GooglePlaces

protocol Coordinator: AnyObject {
    func start()
}

final class AppCoordinator: NSObject, Coordinator {
    
    private let window: UIWindow
    
    private let navigationController = UINavigationController()
    
    private let cityListViewController = CityListViewController.instantiate()
    private let cityListViewModel = CityListViewModel()
    
    private let autocompleteVC = GMSAutocompleteViewController()
    
    private var detailViewControllers = [DetailWeatherViewController]()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        startCityListVC()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func startCityListVC() {
        cityListViewModel.coordinator = self
        cityListViewModel.viewController = cityListViewController
        cityListViewController.viewModel = cityListViewModel
        autocompleteVC.delegate = self
        
        navigationController.pushViewController(cityListViewController, animated: true)
    }
    
    func startPageVC(from indexPath: IndexPath) {
        let vc = detailViewControllers[indexPath.row]
        let pageVC = UIPageViewController(transitionStyle: .scroll,
                                          navigationOrientation: .horizontal,
                                          options: nil)
        
        pageVC.delegate = self
        pageVC.dataSource = self
        pageVC.setViewControllers([vc],
                                  direction: .forward,
                                  animated: true,
                                  completion: nil)
        
        navigationController.pushViewController(pageVC, animated: true)
    }
    
    func startSearchVC() {
        let filter = GMSAutocompleteFilter()
        let fields: GMSPlaceField = [.name, .coordinate]
        filter.type = .city
        autocompleteVC.autocompleteFilter = filter
        autocompleteVC.placeFields = fields
        
        navigationController.present(autocompleteVC, animated: true, completion: nil)
    }
    
    func startDetailVC(_ cityCellModel: CityCellModelProtocol) {
        let (vc, vm) = setupDetailVC()
        
        pushGeolocation(viewModel: vm,
                        name: cityCellModel.name,
                        long: cityCellModel.long,
                        lat: cityCellModel.lat)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentDetailVC(from viewController: UIViewController, with place: GMSPlace) {
        let (vc, vm) = setupDetailVC()
        vc.isModal = true
        
        pushGeolocation(viewModel: vm,
                        name: place.name ?? "",
                        long: String(place.coordinate.longitude),
                        lat: String(place.coordinate.latitude))
        
        viewController.present(vc, animated: true, completion: nil)
    }
    
    func popDetailVC() {
        navigationController.popViewController(animated: true)
    }
    
    func dismissDetailVC(_ viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func addCity(name: String, long: String, lat: String) {
        navigationController.dismiss(animated: true, completion: nil)
        cityListViewModel.addCity(name: name, long: long, lat: lat)
    }
    
    func appendVC(_ viewController: DetailWeatherViewController) {
        detailViewControllers.append(viewController)
    }
    
    func removeVC(at indexPath: IndexPath) {
        detailViewControllers.remove(at: indexPath.row)
    }
    
    private func pushGeolocation(viewModel: DetailWeatherViewViewModel, name: String, long: String, lat: String) {
        viewModel.setGeolocation(name: name, long: long, lat: lat)
    }
    
    private func setupDetailVC() -> (DetailWeatherViewController, DetailWeatherViewViewModel) {
        let viewController = DetailWeatherViewController.instantiate()
        let viewModel = DetailWeatherViewViewModel()
        viewModel.coordinator = self
        viewModel.viewController = viewController
        viewController.viewModel = viewModel
        
        return (viewController, viewModel)
    }
}

// MARK: - GMSAutocompleteViewControllerDelegate

extension AppCoordinator: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        presentDetailVC(from: autocompleteVC, with: place)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        autocompleteVC.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIPageViewControllerDataSource, UIPageViewControllerDelegate

extension AppCoordinator: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = detailViewControllers.firstIndex(of: viewController as! DetailWeatherViewController),
              index > 0 else { return nil }
        
        let before = index - 1
        
        return detailViewControllers[before]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = detailViewControllers.firstIndex(of: viewController as! DetailWeatherViewController),
              index < (detailViewControllers.count - 1) else { return nil }
        
        let after = index + 1
        
        return detailViewControllers[after]
    }
}

