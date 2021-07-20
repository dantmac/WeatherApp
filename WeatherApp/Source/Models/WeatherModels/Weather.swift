//
//  Weather.swift
//  WeatherApp
//
//  Created by admin on 20.07.2021.
//

import Foundation



struct Weather: Decodable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}
