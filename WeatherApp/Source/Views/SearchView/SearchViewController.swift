//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by admin on 30.07.2021.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    static func instantiate() -> SearchViewController {
        let storyboard = UIStoryboard(name: "SearchViewController", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
        return controller
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
