//
//  Extensions.swift
//  WeatherApp
//
//  Created by admin on 25.07.2021.
//

import UIKit
import Foundation
import GooglePlaces

extension StringProtocol {
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}

extension Date {
    func formateToTime(timezoneOffset: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: timezoneOffset) as TimeZone
        return formatter.string(from: self)
    }
    
    func formateToHours(timezoneOffset: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: timezoneOffset) as TimeZone
        return formatter.string(from: self)
    }
    
    func formateToDays() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
}
