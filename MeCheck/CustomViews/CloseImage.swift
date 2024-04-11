//
//  CloseImage.swift
//  MeCheck
//
//  Created by Robert Mutai on 14/03/2024.
//

import SwiftUI

struct CloseImage: View {
    var body: some View {
        Image("close", bundle: .none)
            .resizable()
            .frame(width: 14, height: 14)
            .foregroundStyle(.darkGrey)
            .padding()
            .background(.shadowBackground)
            .overlay(content: { RoundedRectangle(cornerRadius: 28.0, style: .circular)
                .strokeBorder(.lightGrey)}).shadow(color: .shadow, radius: 10)
    }
}

#Preview {
    CloseImage()
}
