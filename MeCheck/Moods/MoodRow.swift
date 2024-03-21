//
//  MoodRow.swift
//  MeCheck
//
//  Created by Robert Mutai on 12/03/2024.
//

import SwiftUI

struct MoodRow: View {
    @State  var dayImage: String
    @State  var dayLabel: String
    @Binding  var feeling: String
    var body: some View {
        HStack {
                Image(dayImage, bundle: .none)
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundStyle(.secondary)
                Text(LocalizedStringKey(stringLiteral: dayLabel))
                .font(.IBMRegular(size: 15))
                Spacer()
                if feeling == "" {
                    HStack {
                        Text("Add")
                            .font(.IBMRegular(size: 15))
                        Image("add_circle", bundle: .none)
                    }
                    .padding(10)
                    .opacity(0.7)
                    .background(.quinary,in: RoundedRectangle(cornerRadius: 10.0, style: .circular))
                } else {
                    Text(feeling)
                        .font(.system(size: 40))
                }
                
                
            }
            .frame(width: 300, height: 30)
    }
}

#Preview {
    MoodRow(dayImage: "wb_twilight", dayLabel: "Morning", feeling: .constant(""))
}
