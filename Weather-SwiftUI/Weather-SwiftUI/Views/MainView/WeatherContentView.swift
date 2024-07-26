//
//  WeatherContentView.swift
//  Weather-SwiftUI
//
//  Created by Dev on 7/23/24.
//

import SwiftUI

struct WeatherContentView: View {
    @Binding var triggerDarkMode: Bool
    @Binding var weather: Weather?
    
    var cityName: String = "Lahore, PK"
    var mainViewModel: MainViewModel?
    
    var body: some View {
        VStack(alignment: .center, spacing: 10){
            Spacer()
            TextLabelView(text: weather?.city ?? cityName, textSize: 40)
                .padding(.vertical, 20)
            
            WeatherInformationView(weather: $weather,
                                   isDarkMode: $triggerDarkMode)
                .padding(.bottom, 30)
            
            HStack(spacing: 15){
                WeatherInformationView(weatherImage: "sun.max",
                                       weatherImageDims: 55,
                                       temperature: 68,
                                       temperatureLabelSize: 25,
                                       dayLabel: "Tue",
                                       weather: $weather,
                                       isDarkMode: $triggerDarkMode)
                
                WeatherInformationView(weatherImage: "cloud.heavyrain",
                                       weatherImageDims: 55,
                                       temperature: 56,
                                       temperatureLabelSize: 25,
                                       dayLabel: "Wed",
                                       weather: $weather,
                                       isDarkMode: $triggerDarkMode)
                
                WeatherInformationView(weatherImage: "cloud.sun.circle",
                                       weatherImageDims: 55,
                                       temperature: 62,
                                       temperatureLabelSize: 25,
                                       dayLabel: "Thu",
                                       weather: $weather,
                                       isDarkMode: $triggerDarkMode)
                
                WeatherInformationView(weatherImage: "wind.circle",
                                       weatherImageDims: 55,
                                       temperature: 65,
                                       temperatureLabelSize: 25,
                                       dayLabel: "Fri",
                                       weather: $weather,
                                       isDarkMode: $triggerDarkMode)
                
                WeatherInformationView(weatherImage: "cloud.snow",
                                       weatherImageDims: 55,
                                       temperature: 45,
                                       temperatureLabelSize: 25,
                                       dayLabel: "Sat",
                                       weather: $weather,
                                       isDarkMode: $triggerDarkMode)
            }
            
            Spacer()
            
            Button {
                self.mainViewModel?.updateLocationAndWeather()
            } label: {
                CustomButtonView(label: "Current Location")
            }
            
            Spacer()
        }
    }
}

struct WeatherInformationView: View {
    var weatherImage: String = "sun.max"
    var weatherImageDims: CGFloat = 130
    var temperature: Int = 36
    var temperatureLabelSize: CGFloat = 40
    var dayLabel: String? = nil
    
    @Binding var weather: Weather?
    @Binding var isDarkMode: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 10){
            if let daylabel = self.dayLabel {
                TextLabelView(text: daylabel, textSize: 20)
            }
            
            Image(systemName: "\(weather?.conditionImageStr ?? weatherImage)\(isDarkMode ? "": ".fill")")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: weatherImageDims, height: weatherImageDims)
            
            Text(weather?.readingString ?? "\(temperature)°")
                .font(.system(size: temperatureLabelSize, weight: .bold))
                .foregroundColor(.white)
        }
    }
}


