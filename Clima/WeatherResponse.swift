//
//  WeatherResponse.swift
//  Clima
//
//  Created by Dev on 6/25/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit

struct WeatherResponse: Decodable {
    let name: String
    let weather: [Weather]
    let main: Main
}
struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
struct Main: Decodable {
    let temp: Float
    let feels_like: Float
}
