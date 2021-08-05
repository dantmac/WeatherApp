//
//  CityListViewModel.swift
//  WeatherApp
//
//  Created by admin on 02.08.2021.
//

import Foundation
import UIKit

protocol CityListPresentationLogic {
    func presentSearchVC()
    func presentDetailWeather()
}

final class CityListViewModel: CityListPresentationLogic {
    
    weak var viewController: CityListDisplayLogic?
    var coordinator: CityListCoordinator?
    
    func presentSearchVC() {
        coordinator?.startSearchVC()
    }
    
    func presentDetailWeather() {
        coordinator?.startDetailVC()
    }
}
