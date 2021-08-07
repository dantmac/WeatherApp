//
//  CityCellViewModel.swift
//  WeatherApp
//
//  Created by admin on 06.08.2021.
//

import Foundation

protocol CityCellModelProtocol {
    var name: String { get }
    var description: String { get }
    var temp: String { get }
    var long: String { get }
    var lat: String { get }
}

struct CityCellModel {
    struct CityCell: CityCellModelProtocol {
        var name: String
        var description: String
        var temp: String
        var lat: String
        var long: String
    }
    
    var cells: [CityCellModelProtocol]
}
