//
//  OpenWeatherAPIManager.swift
//  Clima
//
//  Created by Dev on 6/25/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit

class OpenWeatherAPIManager {
    
    // MARK: - Private Properties
    
    private let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
    private let apiKey = "235f812bb12746e6023c1e0ba40e069b"
    
    // MARK: - Public Properties
    
    var delegate: WeatherViewDelegate?
    
    // MARK: - Public Methods
    
    func fetchWeather(for city: String) {
        let urlString = self.baseUrl + "?units=metric&APPID=\(self.apiKey)&q=\(city)"
        guard let url = URL(string: urlString) else {return}
        self.fetchData(url)
    }
    
    func fetchWeather(lat: Double, long: Double) {
        let urlString = self.baseUrl + "?units=metric&APPID=\(self.apiKey)&lat=\(lat)&lon=\(long)"
        guard let url = URL(string: urlString) else {return}
        self.fetchData(url)
    }
    
    // MARK: - Private Methods
    
    private func fetchData(_ url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let data = data else {return}
            guard let weather = self.parseJSON(data: data) else {return}
            
            let weatherModel = WeatherModel(temp: weather.main.temp, city: weather.name, conditionId: weather.weather[0].id)
            self.delegate?.didUpdateWeather(weather: weatherModel)
        }
        task.resume()
    }
    
    private func parseJSON(data: Data) -> WeatherResponse? {
        do {
            let jsonDecoder = JSONDecoder()
            let decodedWeatherResponse: WeatherResponse = try jsonDecoder.decode(WeatherResponse.self, from: data)
            return decodedWeatherResponse
        }catch{
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func printStringFromData(data: Data) {
        guard let dataString = String(data: data, encoding: .utf8) else {return}
        print(dataString)
    }
}

// MARK: - WeatherViewDelegate

protocol WeatherViewDelegate {
    func didUpdateWeather(weather: WeatherModel)
}
