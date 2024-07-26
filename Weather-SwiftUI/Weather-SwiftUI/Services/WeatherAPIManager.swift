//
//  WeatherAPIManager.swift
//  Weather-SwiftUI
//
//  Created by Dev on 7/23/24.
//

import Foundation
import SwiftUI


protocol MainViewModelDelegate {
    func didUpdateCityList(cityList: [CityDecodable])
    func didUpdateWeather(weather: Weather)
}

class WeatherApiManager: ObservableObject {
    
    static let shared = WeatherApiManager()
    
    private let baseUrlForWeatherApi = "https://api.openweathermap.org/data/2.5/weather"
    private let baseUrlForGeoApi = "https://api.openweathermap.org/geo/1.0/direct"
    private let apiKey = "235f812bb12746e6023c1e0ba40e069b"
    
    public var delegate: MainViewModelDelegate?
    
    private init() {}

    public func fetchCities(searchTerm: String, limit: Int = 10) async {
        guard let url = URL(string: "\(baseUrlForGeoApi)?q=\(searchTerm)&limit=\(limit)&appid=\(apiKey)") else {
            return
        }
        do {
            let cities = try await makeRequestForCities(url)
            self.delegate?.didUpdateCityList(cityList: cities)
        } catch {
            print(error)
        }
    }
    
    func fetchWeather(city: String) {
        let urlString = self.baseUrlForWeatherApi + "?units=metric&APPID=\(self.apiKey)&q=\(city)"
        guard let url = URL(string: urlString) else {return}
        self.fetchData(url)
    }
    
    func fetchWeather(lat: Double, long: Double) {
        let urlString = self.baseUrlForWeatherApi + "?units=metric&APPID=\(self.apiKey)&lat=\(lat)&lon=\(long)"
        guard let url = URL(string: urlString) else {return}
        self.fetchData(url)
    }
    
    // MARK: - Private Methods
    
    private func makeRequestForCities(_ url: URL) async throws -> [CityDecodable] {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedCities = try JSONDecoder().decode([CityDecodable].self, from: data)
        return decodedCities
    }
    
    private func fetchData(_ url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let data = data else {return}
            guard let parsedWeatherObject = self.parseJSON(data: data) else {return}
            
            let weather = Weather(city: parsedWeatherObject.name,
                                  reading: parsedWeatherObject.main.temp,
                                  conditionId: parsedWeatherObject.weather[0].id,
                                  sunrise: parsedWeatherObject.sys.sunrise,
                                  sunset: parsedWeatherObject.sys.sunset)
            self.delegate?.didUpdateWeather(weather: weather)
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
    
}
