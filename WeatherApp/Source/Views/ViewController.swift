//
//  ViewController.swift
//  WeatherApp
//
//  Created by admin on 19.07.2021.
//

import UIKit

class ViewController: UIViewController {

    private let networkService: Networking = NetworkService()
    
            let params = ["lat": "33.44", "lon": "-94.04"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.3529411765, green: 0.7921568627, blue: 0.9647058824, alpha: 1)
        
        networkService.request(params: params) { data, error in
            if let error = error {
                print("Error receiver requesting data: \(error.localizedDescription)")
            }
            
            guard let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            print(json ?? "nil")
        }
    }


}

