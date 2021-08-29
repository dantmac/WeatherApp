//
//  HourlyViewModel.swift
//  WeatherApp
//
//  Created by admin on 25.07.2021.
//

import Foundation

protocol HourlyCellViewModelProtocol {
    var dtHourly: String { get }
    var temp: String { get }
    var weatherIcon: String { get }
}

struct HourlyCellViewModel {
    struct HourlyCell: HourlyCellViewModelProtocol {
        var dtHourly: String
        var temp: String
        var weatherIcon: String
    }
    
    let cells: [HourlyCellViewModelProtocol]
}

