//
//  ContentView.swift
//  Weather-SwiftUI
//
//  Created by Dev on 7/23/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            BackgroundGradientView(topColor: .blue,
                                   bottomColor: Color("ligthBlue"))
            WeatherContentView()
        }
    }
}

struct BackgroundGradientView: View {
    var topColor: Color
    var bottomColor: Color
    
    var body: some View {
        LinearGradient(colors: [topColor, bottomColor], startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
    }
}

struct WeatherContentView: View {
    var body: some View {
        var cityName: String = "Lahore, PK"
        
        VStack(alignment: .center, spacing: 10){
            Spacer()
            TextLabelView(text: cityName, textSize: 40)
                            .padding(.vertical, 20)
            
            WeatherInformationView()
                            .padding(.bottom, 30)
            
            HStack(spacing: 15){
                WeatherInformationView(weatherImage: "sun.max.fill",
                                       weatherImageDims: 55,
                                       temperature: 68,
                                       temperatureLabelSize: 25,
                                       dayLabel: "Tue")
                
                WeatherInformationView(weatherImage: "cloud.heavyrain.fill",
                                       weatherImageDims: 55,
                                       temperature: 56,
                                       temperatureLabelSize: 25,
                                       dayLabel: "Wed")
                
                WeatherInformationView(weatherImage: "cloud.sun.circle.fill",
                                       weatherImageDims: 55,
                                       temperature: 62,
                                       temperatureLabelSize: 25,
                                       dayLabel: "Thu")
                
                WeatherInformationView(weatherImage: "wind.circle.fill",
                                       weatherImageDims: 55,
                                       temperature: 65,
                                       temperatureLabelSize: 25,
                                       dayLabel: "Fri")
                
                WeatherInformationView(weatherImage: "cloud.snow.fill",
                                       weatherImageDims: 55,
                                       temperature: 45,
                                       temperatureLabelSize: 25,
                                       dayLabel: "Sat")
            }
            
            Spacer()
            Button {
                print("HUID")
            } label: {
                CustomButtonView(label: "Update")
            }
            
            Spacer()
            
        }
    }
}

struct TextLabelView: View {
    var text: String
    
    var textColor: Color = .white
    var textSize: CGFloat = 40.0
    
    var body: some View {
        Text(text)
            .font(.system(size: textSize, weight: .bold))
            .foregroundColor(textColor)
    }
    
}


struct WeatherInformationView: View {
    var weatherImage: String = "sun.max.fill"
    var weatherImageDims: CGFloat = 130
    var temperature: Int = 36
    var temperatureLabelSize: CGFloat = 40
    var dayLabel: String? = nil
    
    var body: some View {
        VStack(alignment: .center, spacing: 10){
            if let daylabel = self.dayLabel {
                TextLabelView(text: daylabel, textSize: 20)
            }
            
            Image(systemName: weatherImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: weatherImageDims, height: weatherImageDims)
            
            Text("\(temperature)°")
                .font(.system(size: temperatureLabelSize, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

struct CustomButtonView: View {
    var label: String
    
    var labelSize: CGFloat = 20
    var foregroundColor: Color = .black
    var backgroundColor: Color = .white
    var width: CGFloat = 280
    var height: CGFloat = 50
    var cornerRadius: CGFloat = 10
    
    var body: some View {
        Text (label)
            .foregroundColor(self.foregroundColor)
            .font(.system(size: labelSize, weight: .bold))
            .frame(width: width, height: height)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
        
    }
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
