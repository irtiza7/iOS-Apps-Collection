//
//  ContentViewModel.swift
//  Weather-SwiftUI
//
//  Created by Dev on 7/23/24.
//

/*
 - Import the CoreLocation Package
 - Create a CLLocation object in the VC
 - Call the CLLocation object’s requestWhenInUseAuthorization() method
 - Set object’s delegate property to self  and conform to the CLLocationManagerDelegate by defining locationManager(: didUpdateLocations) and locationManager(: didFailWithError) methods
 - Also add the “Privacy - Location Usage Description” with suitable message in the Info.plist of project
 - Call the object’s updateLocations() method whenever the location is needed
 - The latitude and longitude will be accessible in the locationManager(: didUpdateLocations) method via locations property
 - Call the object’s stopUpdatingLocatios() method if the locations are found
 */

import SwiftUI
import UIKit
import CoreLocation

final class MainViewModel: NSObject, ObservableObject  {
    @Published var cityList: [City] = []
    @Published var weather: Weather?
    @Published var userCurrentLocationCoordinates: (Double, Double)?
    
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
        guard let currentLocation = self.userCurrentLocationCoordinates else {return}
        weatherApiManager.fetchWeather(lat: currentLocation.0, long: currentLocation.1)
    }
    
    func fetchCities(forTerm term: String) {
        Task { await weatherApiManager.fetchCities(searchTerm: term)}
    }
}

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
