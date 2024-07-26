//
//  BackgroundGradientView.swift
//  Weather-SwiftUI
//
//  Created by Dev on 7/23/24.
//

import SwiftUI

struct BackgroundGradientView: View {
    @Binding var isDarkMode: Bool
    
    var colors: [Color] {
        return isDarkMode ? [Color("darkGray"), Color("lightGray")] : [Color.blue, Color("lightBlue")]
    }
    
    var body: some View {
        LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
    }
}
