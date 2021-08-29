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
    
    // MARK: - Formatted properties
    
    var sunriseDate: Date               { return Date(timeIntervalSince1970: Double(sunrise)) }
    
    var sunsetDate: Date                { return Date(timeIntervalSince1970: Double(sunset)) }
    
    var tempCelsiusString: String       { return String(format: "%.f", temp - 273) }
    
    var feelsLikeCelsiusString: String  { return String(format: "%.f", feelsLike - 273) + "º" }
    
    var pressureString: String          { return String(format: "%.1f", Double(pressure) * 0.75 ) + " mm Hg"}
    
    var humidityString: String          { return String(humidity) + " %" }
    
    var uviString: String               { return String(format: "%.f", uvi) }
    
    var cloudsString: String            { return String(clouds) + " %" }
    
    var visibilityString: String        { return String(format: "%.1f", Double(visibility) / 1000) + " km" }
    
    var windSpeedString: String         { return String(format: "%.1f", windSpeed) + " m/s" }
    
    var windDegString: String {
        switch windDeg {
            case 0...11, 350...360: return "N"
            case 12...34:   return "NNE"
            case 35...56:   return "NE"
            case 57...79:   return "ENE"
            case 80...101:  return "E"
            case 102...124: return "ESE"
            case 125...146: return "SE"
            case 147...169: return "SSE"
            case 170...191: return "S"
            case 192...214: return "SSW"
            case 215...236: return "SW"
            case 237...259: return "WSW"
            case 260...281: return "W"
            case 282...304: return "WNW"
            case 305...326: return "NW"
            case 327...349: return "NNW"
            default: return ""
        }
    }
}
