//
//  LandingView.swift
//  MeCheck
//
//  Created by Robert Mutai on 29/04/2024.
//

import SwiftUI

struct LandingView: View {
    @StateObject  var appNavigation: AppNavigation
    @State var isFirstTime = true
    var body: some View {
        VStack {
            Text("MeCheck - Check On Yourself")
                .font(.IBMMedium(size: 18))
            Spacer()
            Text("Mood Tracker, Habit Tracker and Gratitude Journal")
                .font(.IBMRegular(size: 17))
                .multilineTextAlignment(.center)
            Spacer()
            Button("Continue") {
                if isFirstTime {
                    appNavigation.navigate(route: .intro)
                } else {
                    appNavigation.navigate(route: .home)
                }
            }
            .padding(12)
            .background(.purple)
            .clipShape(RoundedRectangle(cornerSize: CGSizeMake(15, 15)))
            .foregroundStyle(.white)
            .font(.IBMMedium(size: 16))
              
        }
        .frame(height:350)
        .padding()
        .onAppear(perform: {
            if isFirstTime {
                appNavigation.navigate(route: .intro)
            } else {
                appNavigation.navigate(route: .home)
            }
        })
    }
}

#Preview {
    LandingView(appNavigation: AppNavigation())
}
