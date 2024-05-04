//
//  LandingView.swift
//  MeCheck
//
//  Created by Robert Mutai on 29/04/2024.
//

import SwiftUI

struct LandingView: View {
    @StateObject  var appNavigation: AppNavigation
    var hasSeenIntro: Bool = UserDefaults.standard.bool(forKey: "hasSeenIntro")
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
                if hasSeenIntro {
                    appNavigation.navigate(route: .home)
                } else {
                    UserDefaults.standard.set(true, forKey: "hasSeenIntro")
                    appNavigation.navigate(route: .intro)
                   
                }
            }
            .padding([.leading,.trailing])
            .padding([.top,.bottom],8)
            .background(.purple)
            .clipShape(RoundedRectangle(cornerSize: CGSizeMake(15, 15)))
            .foregroundStyle(.white)
            .font(.IBMMedium(size: 16))
              
        }
        .frame(height:350)
        .padding()
        .onAppear(perform: {
            if hasSeenIntro {
                appNavigation.navigate(route: .home)
            } else {
                UserDefaults.standard.set(true, forKey: "hasSeenIntro")
                appNavigation.navigate(route: .intro)
            }
        })
    }
}

#Preview {
    LandingView(appNavigation: AppNavigation())
}
