//
//  HourlyCollectionView.swift
//  WeatherApp
//
//  Created by admin on 23.07.2021.
//

import UIKit

class HourlyCollectionView: UICollectionView {
   
    // TODO: comment each group of objects
    
    private var hourlyViewViewModel = HourlyCellViewViewModel()
    
    private var hourlyCellViewModel = HourlyCellViewModel(cells: [])
    
  
    private let reuseID = "HourlyViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
        setCells()
//        print(hourlyCellViewModel)
    }

    private func setupCollectionView() {
        register(HourlyCollectionViewCell.nib(), forCellWithReuseIdentifier: reuseID)
        delegate = self
        dataSource = self
        showsHorizontalScrollIndicator = false
    }
    
    private func setCells() {
        hourlyViewViewModel.setWeather { [weak self] hourlyCellViewModel in
            self?.hourlyCellViewModel = hourlyCellViewModel
            self?.reloadData()
        }
    }

}

extension HourlyCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyCellViewModel.cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! HourlyCollectionViewCell
        let cellViewModel = hourlyCellViewModel.cells[indexPath.row]
        cell.setCell(hourlyCellViewModel: cellViewModel)
        return cell
    }
    
    
}
