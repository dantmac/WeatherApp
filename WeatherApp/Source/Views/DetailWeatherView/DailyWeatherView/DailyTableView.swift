//
//  DailyTableView.swift
//  WeatherApp
//
//  Created by admin on 23.07.2021.
//

import Foundation
import UIKit

class DailyTableView: UITableView {
    
    private var dailyViewViewModel = DailyCellViewViewModel()
    
    private var dailyCellViewModel = DailyCellViewModel(cells: [])
    
    private let reuseID = "DailyViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTableView()
        setCells()
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
    
    private func setCells() {
       dailyViewViewModel.setWeather { [weak self] dailyCellViewModel in
            self?.dailyCellViewModel = dailyCellViewModel
            self?.reloadData()
        }
    }
    
}

extension DailyTableView: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyCellViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! DailyTableViewCell
        let cellViewModel = dailyCellViewModel.cells[indexPath.row]
        cell.setCell(cellViewModel: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
