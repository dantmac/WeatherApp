//
//  SearchViewCell.swift
//  WeatherApp
//
//  Created by admin on 02.08.2021.
//

import UIKit

class SearchViewCell: UITableViewCell {
    
    @IBOutlet weak var cityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    static func nib() -> UINib {
        return UINib(nibName: "SearchViewCell", bundle: nil)
    }
}
