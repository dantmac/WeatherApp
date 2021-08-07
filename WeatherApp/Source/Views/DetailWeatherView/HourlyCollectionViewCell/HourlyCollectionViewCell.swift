//
//  HourlyCollectionViewCell.swift
//  WeatherApp
//
//  Created by admin on 23.07.2021.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dtHourLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "HourlyCollectionViewCell",
                     bundle: nil)
    }
    
    func setCell(_ hourlyCellViewModel: HourlyCellViewModelProtocol) {
        dtHourLabel.text = hourlyCellViewModel.dtHourly
        tempLabel.text = hourlyCellViewModel.temp
        weatherIcon.image = UIImage(named: hourlyCellViewModel.weatherIcon)
        
        if dtHourLabel.text == "Now" {
            dtHourLabel.font = UIFont.boldSystemFont(ofSize: 17)
        }
        
        if tempLabel.text == "Sunrise" || tempLabel.text == "Sunset" {
            bounds.size = CGSize(width: 100, height: 120)
        }
    }
}
