//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by admin on 20.07.2021.
//

import Foundation

struct WeatherResponse: Decodable {
    let current: WeatherCurrent
    let hourly: [WeatherHourly]
    let daily: [WeatherDaily]
}
