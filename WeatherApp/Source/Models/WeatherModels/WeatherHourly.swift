//
//  WeatherHourly.swift
//  WeatherApp
//
//  Created by admin on 20.07.2021.
//

import Foundation

struct WeatherHourly: Decodable {
    var dt: Int
    var temp: Double
    var weather: [Weather]
}
