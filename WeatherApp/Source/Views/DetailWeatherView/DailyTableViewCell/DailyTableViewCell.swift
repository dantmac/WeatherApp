//
//  DailyTableViewCell.swift
//  WeatherApp
//
//  Created by admin on 23.07.2021.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    
    private enum Keys {
        static let nibName = "DailyTableViewCell"
    }
    
    @IBOutlet weak var dtLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    static func nib() -> UINib {
        return UINib(nibName: Keys.nibName, bundle: nil)
    }
    
    func set(viewModel: DailyCellViewModelProtocol) {
        dtLabel.text = viewModel.dtDaily
        weatherIcon.image = UIImage(named: viewModel.weatherIcon)
        tempMaxLabel.text = viewModel.tempMax
        tempMinLabel.text = viewModel.tempMin
    }
}
