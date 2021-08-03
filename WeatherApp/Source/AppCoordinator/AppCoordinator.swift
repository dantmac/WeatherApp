//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by admin on 30.07.2021.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get }
    func start()
}

final class AppCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let navigationController = UINavigationController()
        
        let detailWeatherCoordinator = DetailWeatherCoordinator(navigationController: navigationController)
        
        childCoordinators.append(detailWeatherCoordinator)
        detailWeatherCoordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
