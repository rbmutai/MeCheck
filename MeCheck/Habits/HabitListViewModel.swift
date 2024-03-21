//
//  HabitListViewModel.swift
//  MeCheck
//
//  Created by Robert Mutai on 21/03/2024.
//

import Foundation

class HabitListViewModel: ObservableObject {
    
    @Published var goodHabits: [HabitItem] = [
        HabitItem(id: 1, image: "💦", title: "Drink water", detail: "Drink water to stay healthy", isQuit: false, backgroundColor: HabitColors.Blue.rawValue, habitFrequency: .daily),
        HabitItem(id: 2, image: "📚", title: "Read a book", detail: "Reading is healthy", isQuit: false, backgroundColor: HabitColors.Orange.rawValue, habitFrequency: .daily),
        HabitItem(id: 3, image: "🚶", title: "Go for a walk", detail: "Walking is healthy", isQuit: false, backgroundColor: HabitColors.Pink.rawValue, habitFrequency: .daily),
        HabitItem(id: 4, image: "🤝", title: "Complement someone", detail: "This is good", isQuit: false, backgroundColor: HabitColors.Yellow.rawValue, habitFrequency: .daily),
        HabitItem(id: 5, image: "🏃‍♀️", title: "Exercise", detail: "This is healthy", isQuit: false, backgroundColor: HabitColors.Brown.rawValue, habitFrequency: .daily)]
    
    @Published var badHabits: [HabitItem] = [
        HabitItem(id: 6, image: "🚭", title: "Quit smoking", detail: "Smoking is bad for your health", isQuit: true, backgroundColor: HabitColors.Brown.rawValue, habitFrequency: .daily),
        HabitItem(id: 7, image: "😡", title: "Don't loose your temper", detail: "Loosing your temper hurts those around you", isQuit: true, backgroundColor: HabitColors.Red.rawValue, habitFrequency: .daily),
        HabitItem(id: 8, image: "🍻", title: "Quit alcohol", detail: "Being an alcoholic ruins your life and others", isQuit: true, backgroundColor: HabitColors.Peach.rawValue, habitFrequency: .daily),
        HabitItem(id: 9, image: "🤔", title: "Stop overthinking", detail: "Overthinking can lead to low productivity and stress", isQuit: true, backgroundColor: HabitColors.Sage.rawValue, habitFrequency: .daily),
        HabitItem(id: 10, image: "💆‍♀️", title: "Stop procrastinating", detail: "You loose time and feel bad when you procrastinate", isQuit: true, backgroundColor: HabitColors.Purple.rawValue, habitFrequency: .daily)]
    
}
