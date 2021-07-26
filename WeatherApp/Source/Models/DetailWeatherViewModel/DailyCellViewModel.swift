//
//  DailyCellViewModel.swift
//  WeatherApp
//
//  Created by admin on 26.07.2021.
//

import Foundation

protocol DailyCellViewModelProtocol {
    var dtDaily: String { get }
    var weatherIcon: String { get }
    var tempMax: String { get }
    var tempMin: String { get }
}

struct DailyCellViewModel {
    struct DailyCell: DailyCellViewModelProtocol {
        var dtDaily: String
        var weatherIcon: String
        var tempMax: String
        var tempMin: String
    }
    
    let cells: [DailyCellViewModelProtocol]
}
