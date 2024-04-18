//
//  HomeView.swift
//  MeCheck
//
//  Created by Robert Mutai on 23/02/2024.
//

import SwiftUI
import Combine
struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @StateObject private var appNavigation: AppNavigation = AppNavigation()
    @State  var selectedTab : Int = 1
    var body: some View {
        NavigationStack(path: $appNavigation.navigationPath) {
        TabView(selection: $selectedTab) {
            MoodView(viewModel: MoodViewModel()).tabItem {
                VStack{
                    Image("mindfulness", bundle: .none)
                    Text("Mood")
                }
            }.tag(1)
            HabitView(viewModel: HabitViewModel(), selectedTab: $selectedTab).tabItem {
                VStack{
                    Image("rule", bundle: .none)
                    Text("Habits")
                }
            }.tag(2)
            GratitudeView(viewModel: GratitudeViewModel(), selectedTab: $selectedTab).tabItem {
                VStack{
                    Image("person_celebrate", bundle: .none)
                    Text("Gratitude")
                }
            }.tag(3)
            StatsView(viewModel: StatsViewModel()).tabItem {
                VStack {
                    Image("monitoring", bundle: .none)
                    Text("Stats")
                }
            }.tag(4)
        }.onAppear {
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            appearance.backgroundColor = .shadowBackground
            
            // Use this appearance when scrolling behind the TabView:
            UITabBar.appearance().standardAppearance = appearance
            // Use this appearance when scrolled all the way up:
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
            
    }
        
 }
    
}

#Preview {
    HomeView(viewModel: HomeViewModel(), selectedTab: 1)
}
