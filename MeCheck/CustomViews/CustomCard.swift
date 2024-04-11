//
//  CustomCard.swift
//  MeCheck
//
//  Created by Robert Mutai on 11/04/2024.
//

import Foundation
import SwiftUI
struct CustomCard: ViewModifier {
    var shadowColor: Color = .shadow
    var shadowBackgroundColor: Color  = .shadowBackground
    var strokeColor: Color = .lightGrey
    var cornerRadius: CGFloat = 18
    var shadowRadius: CGFloat = 10
    func body(content: Content) -> some View {
        content
            .background(shadowBackgroundColor)
            .overlay(content: { RoundedRectangle(cornerRadius: cornerRadius, style: .circular)
                .strokeBorder(strokeColor, lineWidth: 1)}).shadow(color: shadowColor, radius: shadowRadius)
           
    }
}
