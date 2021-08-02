//
//  CityListViewModel.swift
//  WeatherApp
//
//  Created by admin on 02.08.2021.
//

import Foundation

protocol CityListPresentationLogic {
    func presentSearchVC()
}

class CityListViewModel: CityListPresentationLogic {
    
    var coordinator: CityListCoordinator?
    
    func presentSearchVC() {
        coordinator?.startSearchVC()
    }
}
