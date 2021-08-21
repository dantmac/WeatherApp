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
    
    // MARK: -  Properties
    
    private let window: UIWindow
    
    private let navigationController = UINavigationController()
    
    private let cityListViewController = CityListViewController.instantiate()
    private let cityListViewModel = CityListViewModel()
    
    private let autocompleteVC = GMSAutocompleteViewController()
    
    private var detailViewControllers = [DetailWeatherViewController]()
    
    // MARK: -  Init
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: -  Routing
    
    func start() {
        startCityListVC()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    // MARK: - Private methods
    
    private func startCityListVC() {
        cityListViewModel.dataFlow = self
        cityListViewModel.viewController = cityListViewController
        cityListViewController.viewModel = cityListViewModel
        autocompleteVC.delegate = self
        
        navigationController.pushViewController(cityListViewController, animated: true)
    }
    
    private func presentDetailVC(from viewController: UIViewController, with place: GMSPlace) {
        let (vc, vm) = setupDetailVC()
        
        vc.isModal = true
        vc.inExistence = cityListViewModel.checkForExistenceCity(placeID: place.placeID ?? "")
        
        pushGeolocation(viewModel: vm,
                        id: place.placeID ?? "",
                        name: place.name ?? "",
                        lon: String(place.coordinate.longitude),
                        lat: String(place.coordinate.latitude))
        
        viewController.present(vc, animated: true, completion: nil)
    }
    
    private func pushGeolocation(viewModel: DetailWeatherViewViewModel, id: String, name: String, lon: String, lat: String) {
        viewModel.setGeolocation(id: id, name: name, lon: lon, lat: lat)
    }
    
    private func preinstallDetailVC(from cityListModel: CityListModel) {
        for city in cityListModel.cells {
            let (vc, vm) = setupDetailVC()
            
            vm.id = city.id
            vm.cityName = city.name
            vm.lat = city.lat
            vm.lon = city.lon
            
            detailViewControllers.append(vc)
        }
    }
    
    private func setupDetailVC() -> (DetailWeatherViewController, DetailWeatherViewViewModel) {
        let viewController = DetailWeatherViewController.instantiate()
        let viewModel = DetailWeatherViewViewModel()
        viewModel.dataFlow = self
        viewModel.viewController = viewController
        viewController.viewModel = viewModel
        
        return (viewController, viewModel)
    }
}

// MARK: - CityListDataFlow

extension AppCoordinator: CityListDataFlow {
    
    func startPageVC(cityCellModel: CityCellModelProtocol, cityListModel: CityListModel, from indexPath: IndexPath) {
        
        preinstallDetailVC(from: cityListModel)
        
        let vc = detailViewControllers[indexPath.row]
        let vm = vc.viewModel as! DetailWeatherViewViewModel
        let pageVC = UIPageViewController(transitionStyle: .scroll,
                                          navigationOrientation: .horizontal,
                                          options: nil)
        
        pageVC.view.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.8, blue: 0.968627451, alpha: 1)
        pageVC.delegate = self
        pageVC.dataSource = self
        pageVC.setViewControllers([vc],
                                  direction: .forward,
                                  animated: true,
                                  completion: nil)
        
        pushGeolocation(viewModel: vm,
                        id: cityCellModel.id,
                        name: cityCellModel.name,
                        lon: cityCellModel.lon,
                        lat: cityCellModel.lat)
        
        navigationController.pushViewController(pageVC, animated: true)
    }
    
    func startSearchVC() {
        let filter = GMSAutocompleteFilter()
        let fields: GMSPlaceField = [.name, .coordinate, .placeID]
        filter.type = .city
        autocompleteVC.autocompleteFilter = filter
        autocompleteVC.placeFields = fields
        
        autocompleteVC.view.alpha = 0.9
        autocompleteVC.tableCellBackgroundColor = .black
        autocompleteVC.tableCellSeparatorColor = .lightGray
        autocompleteVC.primaryTextColor = .gray
        autocompleteVC.primaryTextHighlightColor = .white
        autocompleteVC.secondaryTextColor = .gray
        
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().tintColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UIActivityIndicatorView.appearance().color = .white
        
        navigationController.present(autocompleteVC, animated: true, completion: nil)
    }
}

// MARK: - DetailWeatherDataFlow

extension AppCoordinator: DetailWeatherDataFlow {
    
    func goToCityList() {
        navigationController.popToRootViewController(animated: true)
        detailViewControllers.removeAll()
    }
    
    func dismissDetailVC(viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func addCity(id: String, name: String, lon: String, lat: String) {
        navigationController.dismiss(animated: true, completion: nil)
        cityListViewModel.addCity(id: id, name: name, lon: lon, lat: lat)
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
