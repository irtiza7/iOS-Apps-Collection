//
//  MainView.swift
//  Weather-SwiftUI
//
//  Created by Dev on 7/23/24.
//

import SwiftUI
import Combine

struct MainView: View {
    @ObservedObject private var mainViewModel = MainViewModel()
    
    @State var isDarkMode: Bool = false
    @State var searchTerm: String = ""
    @State var daysTemperature: [Weather]?
    
    init() {
        mainViewModel.delegate = self
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                BackgroundGradientView(isDarkMode: $isDarkMode)
                
                WeatherContentView(triggerDarkMode: $isDarkMode,
                                   weather: $mainViewModel.weather,
                                   mainViewModel: mainViewModel)
            }
        }
        .searchable(text: $searchTerm) {
            ForEach(mainViewModel.cityList) { city in
                Text(city.name)
            }
        }
        .onChange(of: searchTerm) { newValue in
            if(!searchTerm.isEmpty && searchTerm.count > 2) {
                mainViewModel.fetchCities(forTerm: newValue)
            }
        }
        .onAppear(){
            mainViewModel.updateLocationAndWeather()
        }
    }
}

extension MainView: MainViewDelegate {
    mutating func setAppearenceMode(weather: Weather) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeZone = .current
        
        let sunriseDateAndTime = Date(timeIntervalSince1970: Double(weather.sunrise))
        let sunsetDateAndTime = Date(timeIntervalSince1970: Double(weather.sunset))
        
        let sunriseTime = dateFormatter.string(from: sunriseDateAndTime)
        let sunsetTime = dateFormatter.string(from: sunsetDateAndTime)
        
        guard let sunriseHourInt = Int(sunriseTime.components(separatedBy: ":")[0]),
              var sunsetHourInt = Int(sunsetTime.components(separatedBy: ":")[0]) else {return}
        
        sunsetHourInt += 12 // Converting 12 hours time into 24 hours time
        let currentHourInt = Calendar.current.component(.hour, from: Date())
        
        print(sunriseHourInt, sunsetHourInt, currentHourInt)
        
        if  currentHourInt < sunriseHourInt {
            isDarkMode = true
        } else if currentHourInt > sunsetHourInt {
            isDarkMode = true
        }
        print("isDarkMode: \(isDarkMode)")
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
