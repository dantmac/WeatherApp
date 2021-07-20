//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by admin on 20.07.2021.
//

import Foundation

struct WeatherResponse: Decodable {
    var current: WeatherCurrent
    var hourly: [WeatherHourly]
    var daily: [WeatherDaily]
}
