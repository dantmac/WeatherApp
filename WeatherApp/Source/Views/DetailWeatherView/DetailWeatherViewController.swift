//
//  DetailWeatherViewController.swift
//  WeatherApp
//
//  Created by admin on 19.07.2021.
//

import UIKit

protocol DetailViewDisplayLogic: AnyObject {
    func display(detailViewModel: DetailViewModelProtocol)
    func showToastMessage(message: String)
    func reloadData()
}

class DetailWeatherViewController: UIViewController, DetailViewDisplayLogic {
    
    // MARK: - Keys
    
    private enum Keys {
        static let storyboardName = "DetailView"
        static let storyboardID = "DetailWeatherViewController"
        static let hourlyCellID = "HourlyViewCell"
        static let dailyCellID = "DailyViewCell"
    }
    
    // MARK: - Properties
    
    var viewModel: DetailWeatherPresentationLogic?
    
    var isModal = false
    var inExistence = false
    
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
    
    @IBOutlet weak var currentTempView: UIView!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var dailyTableView: UITableView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var toolBarView: UIToolbar!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton:
        UIButton!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel?.presentWeather()
    }
    
    deinit {
        print("deinit from vc")
    }
    
    // MARK: - Setups
    
    static func instantiate() -> DetailWeatherViewController {
        let storyboard = UIStoryboard(name: Keys.storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: Keys.storyboardID) as! DetailWeatherViewController
        return controller
    }
    
    private func setup() {
        view.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.8, blue: 0.968627451, alpha: 1)
        
        setupViews()
    }
    
    private func setupViews() {
        setupCollectionView()
        setupTableView()
        setupButtons()
    }
    
    private func setupCollectionView() {
        hourlyCollectionView.register(HourlyCollectionViewCell.nib(), forCellWithReuseIdentifier: Keys.hourlyCellID)
        hourlyCollectionView.delegate = self
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupTableView() {
        dailyTableView.register(DailyTableViewCell.nib(), forCellReuseIdentifier: Keys.dailyCellID)
        dailyTableView.delegate = self
        dailyTableView.dataSource = self
        dailyTableView.separatorStyle = .none
        dailyTableView.backgroundColor = .clear
        dailyTableView.showsVerticalScrollIndicator = false
    }
    
    private func setupButtons() {
        if isModal {
            
            addButton.isHidden = inExistence
            cancelButton.isHidden = false
            
            separatorView.isHidden = true
            separatorView.removeFromSuperview()
            
            toolBarView.isHidden = true
            toolBarView.removeFromSuperview()
            
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        } else {
            cancelButton.isHidden = true
            addButton.isHidden = true
        }
    }
    
    // MARK: - Display Logic
    
    func display(detailViewModel: DetailViewModelProtocol) {
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
    }
    
    func showToastMessage(message: String) {
        Toast.show(message: message, controller: self)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.dailyTableView.reloadData()
            self.hourlyCollectionView.reloadData()
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        viewModel?.dismissVC(viewController: self)
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        viewModel?.addCityToCityList()
        isModal = false
        inExistence = false
    }
    
    @IBAction func goToCityList(_ sender: UIBarButtonItem) {
        viewModel?.goToCityList()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension DetailWeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let numberOfItems = viewModel?.countHourlyCells() else { return 26 }
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Keys.hourlyCellID, for: indexPath) as! HourlyCollectionViewCell
        
        guard let cellViewModel = viewModel?.setHourlyViewModel(for: indexPath) else { return cell }
        
        cell.set(viewModel: cellViewModel)
        return cell
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension DetailWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = viewModel?.countDailyCells() else { return 8 }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.dailyCellID, for: indexPath) as! DailyTableViewCell
        
        guard let cellViewModel = viewModel?.setDailyViewModel(for: indexPath) else { return cell }
        
        cell.set(viewModel: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
