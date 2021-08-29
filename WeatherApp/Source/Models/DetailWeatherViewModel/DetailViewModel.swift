//
//  DetailViewModel.swift
//  WeatherApp
//
//  Created by admin on 24.07.2021.
//

import Foundation

protocol DetailViewModelProtocol {
    var location: String { get }
    var description: String { get }
    var temp: String { get }
    var tempMax: String { get }
    var tempMin: String { get }
    var sunrise: String { get }
    var sunset: String { get }
    var humidity: String { get }
    var cloudiness: String { get }
    var windSpeed: String { get }
    var windDeg: String { get }
    var feelsLike: String { get }
    var pressure: String { get }
    var visibility: String { get }
    var uvi: String { get }
}

struct DetailViewModel: DetailViewModelProtocol {
    var location: String
    var description: String
    var temp: String
    var tempMax: String
    var tempMin: String
    var sunrise: String
    var sunset: String
    var humidity: String
    var cloudiness: String
    var windSpeed: String
    var windDeg: String
    var feelsLike: String
    var pressure: String
    var visibility: String
    var uvi: String
}

