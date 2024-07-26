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
    
    @State var searchTerm: String = ""
    @State var daysTemperature: [Weather]?
    
    var body: some View {
        NavigationStack{
            ZStack{
                BackgroundGradientView(isDarkMode: $mainViewModel.isDarkMode)
                
                WeatherContentView(triggerDarkMode: $mainViewModel.isDarkMode,
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
