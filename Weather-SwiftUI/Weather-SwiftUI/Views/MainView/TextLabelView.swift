//
//  TextLabelView.swift
//  Weather-SwiftUI
//
//  Created by Dev on 7/23/24.
//

import SwiftUI

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
