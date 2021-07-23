//
//  ViewController.swift
//  WeatherApp
//
//  Created by admin on 19.07.2021.
//

import UIKit

class ViewController: UIViewController {

    private var weatherDetailViewModel = WeatherDetailViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.3529411765, green: 0.7921568627, blue: 0.9647058824, alpha: 1)
        weatherDetailViewModel.getWeather()
    }
    
    func setData() {
        
    }
}

