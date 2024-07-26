//
//  CityResponse.swift
//  Weather-SwiftUI
//
//  Created by Dev on 7/23/24.
//

import Foundation

struct City: Identifiable, Hashable {
    var id: Int
    var name: String
    var country: String
    var state: String?
    var lat: Float
    var lon: Float
}

struct CityDecodable: Decodable {
    var name: String
    var country: String
    var state: String?
    var lat: Float
    var lon: Float
}
