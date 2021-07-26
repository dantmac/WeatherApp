//
//  DailyTableViewCell.swift
//  WeatherApp
//
//  Created by admin on 23.07.2021.
//

import UIKit

class DailyTableViewCell: UITableViewCell {

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
        return UINib(nibName: "DailyTableViewCell",
                     bundle: nil)
    }
    
    func setCell(cellViewModel: DailyCellViewModelProtocol) {
        dtLabel.text = cellViewModel.dtDaily
        weatherIcon.image = UIImage(named: cellViewModel.weatherIcon)
        tempMaxLabel.text = cellViewModel.tempMax
        tempMinLabel.text = cellViewModel.tempMin
    }
}
