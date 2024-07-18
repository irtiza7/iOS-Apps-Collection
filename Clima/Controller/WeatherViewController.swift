//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let apiManager = OpenWeatherAPIManager()
    private let locationManager = CLLocationManager()

    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var citySearchBar: UITextField!
    
    // MARK: - LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.apiManager.delegate = self
        self.citySearchBar.delegate = self
        
        locationManager.requestLocation()
    }

    // MARK: - IBAction Methdods
    
    @IBAction func searchIconPresssed(_ sender: UIButton) {
        self.citySearchBar.endEditing(true)
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    // MARK: - Private Methods
    
    private func getWeatherFromAPI() {
        guard let city = self.citySearchBar.text else {return}
        self.apiManager.fetchWeather(for: city)
    }
}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return textField.text != ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.getWeatherFromAPI()
        self.citySearchBar.text = ""
    }
}

// MARK: - WeatherViewDelegate

extension WeatherViewController: WeatherViewDelegate {
    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.city
            self.temperatureLabel.text = weather.tempString
            self.conditionImageView.image = UIImage(systemName: weather.conditionImageName)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else {return}
        self.locationManager.stopUpdatingLocation()
        self.apiManager.fetchWeather(lat: loc.coordinate.latitude, long: loc.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
