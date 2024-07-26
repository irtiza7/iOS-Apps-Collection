//
//  WeatherResponse.swift
//  Weather-SwiftUI
//
//  Created by Dev on 7/26/24.
//

import Foundation

struct WeatherResponse: Decodable {
    let id: Int
    let name: String
    let cod: Int
    let timezone: Int
    let dt: Int
    let visibility: Int
    let base: String
    
    let main: Main
    let weather: [WeatherObject]
    let coord: Coord
    let sys: Sys
    let clouds: Clouds
}

struct Main: Decodable {
    let temp: Float
    let feels_like: Float
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    let sea_level: Int
    let grnd_level: Int
}

struct WeatherObject: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Sys: Decodable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}

struct Coord: Decodable {
    let lat: Double
    let lon: Double
}

struct Wind: Decodable {
    let speed: Double
    let deg: Int
}

struct Clouds: Decodable {
    let all: Int
}
