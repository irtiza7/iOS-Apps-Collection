//
//  MainView.swift
//  Weather-SwiftUI
//
//  Created by Dev on 7/23/24.
//

import SwiftUI

struct MainView: View {
    @ObservedObject private var mainViewModel = MainViewModel()
    
    @State var isDarkMode: Bool = false
    @State var searchTerm: String = ""
    @State var daysTemperature: [Weather]?
    
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
                Text(city.name).searchCompletion(city.name)
            }
        }
        .onChange(of: searchTerm) { newValue in
            if(!searchTerm.isEmpty && searchTerm.count > 2) {
                mainViewModel.fetchCities(forTerm: newValue)
            }
        }
        .onAppear(){
            setAppearenceMode()
            mainViewModel.updateLocationAndWeather()
        }
    }
    
    func setAppearenceMode() {
        let currentHour = Calendar.current.component(.hour, from: Date())
        
        if  currentHour < 6 {
            self.isDarkMode = true
        } else if currentHour > 18 {
            self.isDarkMode = true
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
