//
//  CityListViewModel.swift
//  WeatherApp
//
//  Created by admin on 02.08.2021.
//

import Foundation

protocol CityListPresentationLogic {
    func presentSearchVC()
    func viewDidDisappear()
}

final class CityListViewModel: CityListPresentationLogic {
    
    weak var viewController: CityListDisplayLogic?
    var coordinator: CityListCoordinator?
    
    func presentSearchVC() {
        coordinator?.startSearchVC()
    }
    
    func viewDidDisappear() {
        coordinator?.didFinish()
    }
}
