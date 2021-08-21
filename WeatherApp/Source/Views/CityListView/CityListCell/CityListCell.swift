//
//  CityListCell.swift
//  WeatherApp
//
//  Created by admin on 02.08.2021.
//

import UIKit

class CityListCell: UITableViewCell {
    
    private enum Keys {
        static let nibName = "CityListCell"
    }

    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: Keys.nibName, bundle: nil)
    }
    
    func set(viewModel: CityCellModelProtocol) {
        tempLabel.text = viewModel.temp
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
    }
    
}
