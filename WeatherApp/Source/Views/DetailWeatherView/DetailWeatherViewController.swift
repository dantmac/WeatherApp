//
//  DetailWeatherViewController.swift
//  WeatherApp
//
//  Created by admin on 19.07.2021.
//

import UIKit

protocol DetailViewDisplayLogic: AnyObject {
    func displayDetailWeather(detailViewModel: DetailViewModelProtocol)
}

class DetailWeatherViewController: UIViewController, DetailViewDisplayLogic {
    
    // MARK: - Properties
    
    var viewModel: DetailWeatherPresentationLogic?
    
    private let hourlyCellID = "HourlyViewCell"
    private let dailyCellID = "DailyViewCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cloudinessLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDegLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var uviLabel: UILabel!
    
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var dailyTableView: UITableView!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupViews()
        
        viewModel?.presentWeather()
    }
    
    // MARK: - Setups
    
    func setup() {
        let viewController = self
        let viewModel = DetailWeatherViewViewModel()
        viewController.viewModel = viewModel
        viewModel.viewController = viewController
        
        view.backgroundColor = #colorLiteral(red: 0.2551917757, green: 0.7989619708, blue: 0.9686274529, alpha: 1)
    }
    
    private func setupViews() {
        setupCollectionView()
        setupTableView()
    }
    
    private func setupCollectionView() {
        hourlyCollectionView.register(HourlyCollectionViewCell.nib(), forCellWithReuseIdentifier: hourlyCellID)
        hourlyCollectionView.delegate = self
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupTableView() {
        dailyTableView.register(DailyTableViewCell.nib(), forCellReuseIdentifier: dailyCellID)
        dailyTableView.delegate = self
        dailyTableView.dataSource = self
        dailyTableView.separatorStyle = .none
        dailyTableView.backgroundColor = .clear
        dailyTableView.showsVerticalScrollIndicator = false
    }
    
    func displayDetailWeather(detailViewModel: DetailViewModelProtocol) {
        locationLabel.text = detailViewModel.location
        descriptionLabel.text = detailViewModel.description
        tempLabel.text = detailViewModel.temp
        tempMaxLabel.text = detailViewModel.tempMax
        tempMinLabel.text = detailViewModel.tempMin
        sunriseLabel.text = detailViewModel.sunrise
        sunsetLabel.text = detailViewModel.sunset
        humidityLabel.text = detailViewModel.humidity
        cloudinessLabel.text = detailViewModel.cloudiness
        windSpeedLabel.text = detailViewModel.windSpeed
        windDegLabel.text = detailViewModel.windDeg
        feelsLikeLabel.text = detailViewModel.feelsLike
        pressureLabel.text = detailViewModel.pressure
        visibilityLabel.text = detailViewModel.visibility
        uviLabel.text = detailViewModel.uvi
        degreeLabel.text = "º"
        
        DispatchQueue.main.async {
            self.dailyTableView.reloadData()
            self.hourlyCollectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension DetailWeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = viewModel?.hourlyCellViewModel.cells.count else { return 25 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: hourlyCellID, for: indexPath) as! HourlyCollectionViewCell

        guard let cellViewModel = viewModel?.setHourlyViewModel(for: indexPath) else { return cell }
        
        cell.setCell(hourlyCellViewModel: cellViewModel)
        return cell
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension DetailWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel?.dailyCellViewModel.cells.count else { return 8 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: dailyCellID, for: indexPath) as! DailyTableViewCell
     
        guard let cellViewModel = viewModel?.setDailyViewModel(for: indexPath) else { return cell }
        
        cell.setCell(dailyCellViewModel: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}