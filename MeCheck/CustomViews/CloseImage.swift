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
            .foregroundStyle(.secondary)
            .padding()
            .background(.quinary,in: RoundedRectangle(cornerRadius: 28, style: .circular))
    }
}

#Preview {
    CloseImage()
}
