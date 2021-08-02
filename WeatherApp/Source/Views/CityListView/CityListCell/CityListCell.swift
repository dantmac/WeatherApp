//
//  CityListCell.swift
//  WeatherApp
//
//  Created by admin on 02.08.2021.
//

import UIKit

class CityListCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "CityListCell", bundle: nil)
    }
    
}
