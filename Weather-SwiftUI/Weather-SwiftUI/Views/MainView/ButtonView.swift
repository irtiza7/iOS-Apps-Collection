//
//  ButtonView.swift
//  Weather-SwiftUI
//
//  Created by Dev on 7/23/24.
//

import SwiftUI

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
