//
//  ContentViewModel.swift
//  Weather-SwiftUI
//
//  Created by Dev on 7/23/24.
//

import SwiftUI
import UIKit
import CoreLocation
import Combine

final class MainViewModel: NSObject, ObservableObject  {
    @Published var cityList: [City] = []
    @Published var weather: Weather?
    @Published var userCurrentLocationCoordinates: (Double, Double)?
    @Published var isDarkMode: Bool = false
    
    private let weatherApiManager = WeatherApiManager.shared
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        weatherApiManager.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func updateLocationAndWeather() {
        locationManager.requestLocation()
    }
    
    func getWeather() {
        guard let (lat, lon) = self.userCurrentLocationCoordinates else {return}
        weatherApiManager.fetchWeather(lat: lat, long: lon)
//        weatherApiManager.fetchWeather(city: "Lahore") //TODO: - remove
    }
    
    func fetchCities(forTerm term: String) {
        Task { await weatherApiManager.fetchCities(searchTerm: term)}
    }
    
    private func setAppearenceMode() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeZone = .current
        
        guard let weather else { return }
        let sunriseDateAndTime = Date(timeIntervalSince1970: Double(weather.sunrise))
        let sunsetDateAndTime = Date(timeIntervalSince1970: Double(weather.sunset))
        
        let sunriseTime = dateFormatter.string(from: sunriseDateAndTime)
        let sunsetTime = dateFormatter.string(from: sunsetDateAndTime)
        
        guard let sunriseHourInt = Int(sunriseTime.components(separatedBy: ":")[0]),
              var sunsetHourInt = Int(sunsetTime.components(separatedBy: ":")[0]) else {return}
        
        sunsetHourInt += 12 // Converting 12 hours time into 24 hours time
        let currentHourInt = Calendar.current.component(.hour, from: Date())
        
        if  currentHourInt < sunriseHourInt {
            isDarkMode = true
        } else if currentHourInt > sunsetHourInt {
            isDarkMode = true
        } else {
            isDarkMode = false
        }
    }
}

// MARK: - Delegate Methods

extension MainViewModel: MainViewModelDelegate {
    func didUpdateCityList(cityList: [CityDecodable]) {
        DispatchQueue.main.async {
            self.cityList = []
            for (index, city) in cityList.enumerated() {
                let city = City(id: index, name: city.name, country: city.country, state: city.state, lat: city.lat, lon: city.lon)
                self.cityList.append(city)
            }
        }
    }
    
    func didUpdateWeather(weather: Weather) {
        DispatchQueue.main.async {
            self.weather = weather
            self.setAppearenceMode()
        }
    }
}

// MARK: - CLLocationManagerDelegate Methods

extension MainViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {return}
        locationManager.stopUpdatingLocation()
        
        DispatchQueue.main.async {
            self.userCurrentLocationCoordinates = (lastLocation.coordinate.latitude, lastLocation.coordinate.longitude)
            self.getWeather()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

