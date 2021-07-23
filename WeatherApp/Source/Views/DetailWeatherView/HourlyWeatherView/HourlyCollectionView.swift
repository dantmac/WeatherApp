//
//  HourlyCollectionView.swift
//  WeatherApp
//
//  Created by admin on 23.07.2021.
//

import UIKit

class HourlyCollectionView: UICollectionView {
    
    private let reuseID = "HourlyViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

    private func setupCollectionView() {
        register(HourlyCollectionViewCell.nib(), forCellWithReuseIdentifier: reuseID)
        delegate = self
        dataSource = self
        showsHorizontalScrollIndicator = false
    }

}

extension HourlyCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! HourlyCollectionViewCell
        return cell
    }
    
    
}
