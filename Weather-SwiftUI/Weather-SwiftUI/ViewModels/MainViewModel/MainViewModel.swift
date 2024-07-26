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
    
    private let weatherApiManager = WeatherApiManager.shared
    private let locationManager = CLLocationManager()
    private var cancellable: AnyCancellable?
    
    public var delegate: MainViewDelegate?
    
    override init() {
        super.init()
        
        weatherApiManager.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        initSubscriptions()
    }
    
    convenience init(delegate: MainViewDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    deinit{
        self.cancellable?.cancel()
    }
    
    func initSubscriptions() {
        self.cancellable = self.$weather.sink(receiveValue: { weather in
            guard let weather = weather else {return}
            self.delegate?.setAppearenceMode(weather: weather)
        })
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


protocol MainViewDelegate {
    mutating func setAppearenceMode(weather: Weather)
}
