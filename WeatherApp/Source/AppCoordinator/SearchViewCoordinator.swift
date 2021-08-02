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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchViewController = SearchViewController.instantiate()
        navigationController.present(searchViewController, animated: true, completion: nil)
//        navigationController.show(searchViewController, sender: nil)
    }
}
