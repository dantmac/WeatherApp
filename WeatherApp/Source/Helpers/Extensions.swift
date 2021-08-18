//
//  Extensions.swift
//  WeatherApp
//
//  Created by admin on 25.07.2021.
//

import UIKit
import Foundation
import GooglePlaces

extension String {
    func deletingPrefix() -> String {
        let newString = self.components(separatedBy: "/")
        return newString[1]
    }
}

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

extension UIViewController {
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.size.height - 100, width: self.view.frame.size.width, height: 35))
        toastLabel.backgroundColor = .red.withAlphaComponent(0.6)
        toastLabel.textColor = .white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 4, options: .curveEaseInOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
