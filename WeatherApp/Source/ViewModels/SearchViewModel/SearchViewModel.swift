//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by admin on 03.08.2021.
//

import Foundation

protocol SearchViewPresentationLogic {
    func viewDidDisappear()
    func didCancelSearching()
}

final class SearchViewModel: SearchViewPresentationLogic {
    
   weak var viewController: SearchViewDisplayLogic?
    var coordinator: SearchViewCoordinator?
    
    func didCancelSearching() {
        coordinator?.didCancelSearching()
    }
    
    func viewDidDisappear() {
        coordinator?.didFinish()
    }
}
