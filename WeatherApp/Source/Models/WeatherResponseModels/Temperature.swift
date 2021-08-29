//
//  Temperature.swift
//  WeatherApp
//
//  Created by admin on 20.07.2021.
//

import Foundation

struct Temperature: Decodable {
    let max: Double
    let min: Double
    
    // MARK: - Formatted properties
    
    var maxCelsiusString: String { return String(format: "%.f", max - 273) + "º" }
    
    var minCelsiusString: String { return String(format: "%.f", min - 273) + "º" }
}
