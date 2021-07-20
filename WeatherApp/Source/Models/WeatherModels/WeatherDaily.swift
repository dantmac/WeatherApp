//
//  WeatherDaily.swift
//  WeatherApp
//
//  Created by admin on 20.07.2021.
//

import Foundation

struct WeatherDaily: Decodable {
    var dt: Int
    var temp: [Temperature]
    var weather: [Weather]
}
