//
//  WeatherCurrent.swift
//  WeatherApp
//
//  Created by admin on 20.07.2021.
//

import Foundation

struct WeatherCurrent: Decodable {
    var dt: Int
    var sunrise: Int
    var sunset: Int
    var temp: Double
    var feelsLike: Double
    var pressure: Int
    var humidity: Int
    var uvi: Double
    var clouds: Int
    var visibility: Int
    var windSpeed: Double
    var windDeg: Int
    var weather: [Weather]
}
