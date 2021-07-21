//
//  WeatherHourly.swift
//  WeatherApp
//
//  Created by admin on 20.07.2021.
//

import Foundation

struct WeatherHourly: Decodable {
    let dt: Int
    let temp: Double
    let weather: [Weather]
}
