//
//  WeatherDaily.swift
//  WeatherApp
//
//  Created by admin on 20.07.2021.
//

import Foundation

struct WeatherDaily: Decodable  {
    let dt: Int
    let temp: Temperature
    let weather: [Weather]
    
    // MARK: - Formatted properties
    
    var dtDate: Date { return Date(timeIntervalSince1970: Double(dt)) }
}
