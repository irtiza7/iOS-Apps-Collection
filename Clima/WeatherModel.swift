//
//  WeatherModel.swift
//  Clima
//
//  Created by Dev on 6/26/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let temp: Float
    let city: String
    let conditionId: Int
    
    var tempString: String {
        return String(format: "%.1f", temp)
    }
    
    var conditionImageName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.heavyrain"
        case 600...622:
            return "cloud.snow"
        case 700...781:
            return "sun.dust"
        case 800:
            return "sun.min"
        case 801...804:
            return "cloud"
        default:
            return "sun.min"
        }
    }
}
