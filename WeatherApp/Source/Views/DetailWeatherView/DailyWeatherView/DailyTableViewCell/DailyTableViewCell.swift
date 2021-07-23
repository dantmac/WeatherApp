//
//  DailyTableViewCell.swift
//  WeatherApp
//
//  Created by admin on 23.07.2021.
//

import UIKit

class DailyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    static func nib() -> UINib {
        return UINib(nibName: "DailyTableViewCell",
                     bundle: nil)
    }
    
}
