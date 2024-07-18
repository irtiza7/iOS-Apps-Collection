//
//  ContentView.swift
//  Business Card
//
//  Created by Dev on 7/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(red: 0.086, green: 0.62, blue: 0.521)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image("MyPic")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay( // adds an overly of circle shape
                        Circle()
                            .stroke(Color.white, lineWidth: 5)
                    )
                Text("M. Irtiza")
                    .foregroundColor(.white)
                    .font(.system(size: 35))
                    .fontWeight(.bold)
                Text("Associate Software Engineer")
                    .foregroundColor(Color(.systemGray6))
                    .font(.system(size: 22))
                Divider()
                    .padding()
                CustomRoundedRectangle(text: "03301234567", iconName: "phone")
                    .padding(.horizontal)
                CustomRoundedRectangle(text: "irtiza@gmail.com", iconName: "envelope")
                    .padding(.all)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CustomRoundedRectangle: View {
    var text: String
    var iconName: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 22)
            .fill(Color.white) // Sets the color of rectangle
            .frame(height: 45) // Height of rectangle
            .overlay( // adds an overly of text
                HStack {
                    Image(systemName: "\(iconName).fill")
                        .foregroundColor(.green)
                    Text(text)
                    .foregroundColor(.black)
                .font(.system(size: 20))
                }
            )
    }
}
