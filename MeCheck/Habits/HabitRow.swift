//
//  HabitRow.swift
//  MeCheck
//
//  Created by Robert Mutai on 21/03/2024.
//

import SwiftUI

struct HabitRow: View {
    @State  var habitImage: String
    @State  var habitLabel: String
    @State  var habitBackround: String
    var body: some View {
        HStack {
            Text(habitLabel)
                .font(.IBMMedium(size: 15))
                .padding([.leading],20)
            Spacer()
            Text(habitImage)
                .font(.system(size: 30))
                .padding(8)
                .background(Color(habitBackround, bundle: .main),in: RoundedRectangle(cornerRadius: 10.0, style: .circular))
        }
        .overlay(content: { RoundedRectangle(cornerRadius: 10.0, style: .circular)
            .strokeBorder(.lightGrey)})
        .contentShape(Rectangle())
        
    }
}

#Preview {
    HabitRow(habitImage: "💦", habitLabel: "Drink Water", habitBackround: HabitColors.Blue.rawValue)
}
