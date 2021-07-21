//
//  WeatherCurrent.swift
//  WeatherApp
//
//  Created by admin on 20.07.2021.
//

import Foundation

struct WeatherCurrent: Decodable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let uvi: Double
    let clouds: Int
    let visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]
}
