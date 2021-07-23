//
//  DailyTableView.swift
//  WeatherApp
//
//  Created by admin on 23.07.2021.
//

import Foundation
import UIKit

class DailyTableView: UITableView {
    
    private let reuseID = "DailyViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
    }

    
    private func setupTableView() {
        register(DailyTableViewCell.nib(),
                           forCellReuseIdentifier: reuseID)
        delegate = self
        dataSource = self
        separatorStyle = .none
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
    }
    
}

extension DailyTableView: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! DailyTableViewCell

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
}
