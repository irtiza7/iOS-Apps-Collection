//
//  Temperature.swift
//  Weather-SwiftUI
//
//  Created by Dev on 7/23/24.
//

import Foundation

struct Weather {
    let city: String
    let reading: Float
    let conditionId: Int
    let sunrise: Int
    let sunset: Int
    var day: String?

    var readingString: String {
        String(format: "%.0f°", reading)
    }
    var conditionImageStr: String {
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
