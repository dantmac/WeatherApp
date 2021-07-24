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
        
        view.backgroundColor = #colorLiteral(red: 0.5675834311, green: 0.8398373816, blue: 0.9686274529, alpha: 1)
        weatherDetailViewModel.getWeather()
    }
    
    func setData() {
        
    }
}

