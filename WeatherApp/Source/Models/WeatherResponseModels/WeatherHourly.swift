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
    
    // MARK: - Formatted properties
    
    var dtDate: Date                { return Date(timeIntervalSince1970: Double(dt)) }
    
    var tempCelsiusString: String   { return String(format: "%.f", temp - 273) + "º" }
}
