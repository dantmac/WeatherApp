//
//  Weather.swift
//  WeatherApp
//
//  Created by admin on 20.07.2021.
//

import Foundation

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
