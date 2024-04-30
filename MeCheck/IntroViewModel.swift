//
//  IntroViewModel.swift
//  MeCheck
//
//  Created by Robert Mutai on 24/04/2024.
//

import Foundation

class IntroViewModel: ObservableObject {
    //[String(localized: "MeCheck - Check On Yourself"):String(localized: "Mood Tracker, Habit Tracker and Gratitude Journal")], 
    @Published var introMessage: [IntroItem] = [
        IntroItem(id: 1, title: String(localized: "Moods"), detail: String(localized: "Keep track of how you feel throughout the day"), icon: "moodscreen"),
        IntroItem(id: 2, title: String(localized: "Habits"), detail: String(localized: "Set good habits and break bad ones"), icon: "habitscreen"),
        IntroItem(id: 3, title: String(localized: "Gratitude"), detail: String(localized: "Keep a gratutude journal to help you remember all the good things that happened during the day"), icon: "gratitudescreen"),
        IntroItem(id: 4, title: String(localized: "Statistics"), detail: String(localized: "Generate interesting and useful statistics that help you notice patterns and trends"), icon: "statsscreen")
        ]
    private var appNavigation: AppNavigation
    
    init(appNavigation: AppNavigation) {
        self.appNavigation = appNavigation
    }
    
    func goHome() {
        appNavigation.navigate(route: .home)
    }
   
}
