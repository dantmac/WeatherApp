//
//  CityListModel.swift
//  WeatherApp
//
//  Created by admin on 06.08.2021.
//

import Foundation

protocol CityCellModelProtocol {
    var id: String { get }
    var name: String { get }
    var description: String { get }
    var temp: String { get }
    var lon: String { get }
    var lat: String { get }
    var dateAdded: Date { get }
}

struct CityListModel {
    struct CityCellModel: CityCellModelProtocol {
        var id: String
        var name: String
        var description: String
        var temp: String
        var lat: String
        var lon: String
        var dateAdded: Date
    }
    
    var cells: [CityCellModelProtocol]
}
