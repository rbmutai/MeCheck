//
//  Persistence.swift
//  MeCheck
//
//  Created by Robert Mutai on 23/02/2024.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer
    let viewContext: NSManagedObjectContext

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "MeCheck")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                
               // fatalError("Unresolved error \(error), \(error.userInfo)")
                
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        viewContext = container.viewContext
        viewContext.mergePolicy = NSMergePolicy.rollback
    }
    
    //QUOTES
    func saveQuote(quoteItem: QuoteItem) {
        
        if let quoteEntity = NSEntityDescription.entity(forEntityName: "Quote", in: viewContext){
            let quoteObject = NSManagedObject(entity: quoteEntity, insertInto: viewContext)
            quoteObject.setValue(quoteItem.daily.id, forKey: "id")
            quoteObject.setValue(quoteItem.daily.author, forKey: "author")
            quoteObject.setValue(quoteItem.daily.detail, forKey: "detail")
            quoteObject.setValue(quoteItem.date, forKey: "date")
            quoteObject.setValue(quoteItem.backgroundId, forKey: "backgroundId")
        }
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    func getQuote() -> QuoteItem? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Quote")
        
        do {
            let quoteObject = try viewContext.fetch(fetchRequest)
              if let item = quoteObject.first {
                let id = item.value(forKey: "id") as? Int ?? -1
                let author = item.value(forKey: "author") as? String ?? ""
                let detail = item.value(forKey: "detail") as? String ?? ""
                let date = item.value(forKey: "date") as? Date ?? .distantFuture
                let backgroundId = item.value(forKey: "backgroundId") as? Int ?? -1

                  let quote = QuoteItem(daily: DailyQuote(id: id, detail: detail, author: author), backgroundId: backgroundId, date: date)
                
                return quote
            }
            
            
            return .none
            
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
        
        return .none
    }
    
    func deleteQuote() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Quote")
        do {
            let quoteObject = try viewContext.fetch(fetchRequest)
            for item in quoteObject {
                viewContext.delete(item)
            }
            try viewContext.save()
            
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
    }
    
    //MOODS
    func saveMood(mood: MoodItem) {
        if let moodEntity = NSEntityDescription.entity(forEntityName: "Mood", in: viewContext){
            let moodObject = NSManagedObject(entity: moodEntity, insertInto: viewContext)
            moodObject.setValue(mood.id, forKey: "id")
            moodObject.setValue(mood.morning, forKey: "morning")
            moodObject.setValue(mood.afternoon, forKey: "afternoon")
            moodObject.setValue(mood.date, forKey: "date")
        }
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getMoodForDay(date: Date) -> MoodItem? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Mood")
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        let predicate = NSPredicate(format: "date >= %@ AND date < %@", argumentArray: [startDate, endDate])
        fetchRequest.predicate = predicate
        
        do {
            let moodObject = try viewContext.fetch(fetchRequest)
              if let item = moodObject.first {
                let id = item.value(forKey: "id") as? Int ?? -1
                let morning = item.value(forKey: "morning") as? String ?? ""
                let afternoon = item.value(forKey: "afternoon") as? String ?? ""
                let evening = item.value(forKey: "evening") as? String ?? ""
                let date = item.value(forKey: "date") as? Date ?? .distantFuture
                
                let moodItem = MoodItem(id: id, morning: morning, afternoon: afternoon, evening: evening, date: date)
                
                return moodItem
            }
            
            
            return .none
            
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
        
        return .none
    }
   
    func getMoodData(date: Date, frequency: Frequency) -> [MoodItem] {
        var moodData: [MoodItem] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Mood")
        
         if frequency == .monthly {
            let startDate = getThisMonthStart(date: date)
            let endDate = getThisMonthEnd(date: date)
            fetchRequest.predicate = NSPredicate(format: "date > %@ AND date <= %@", argumentArray: [startDate, endDate])
        } else if frequency == .yearly {
            let startDate = getThisYearStart(date: date)
            let endDate = getThisYearEnd(date: date)
            fetchRequest.predicate = NSPredicate(format: "date > %@ AND date <= %@", argumentArray: [startDate, endDate])
        }
       
        
        do {
            let moodObject = try viewContext.fetch(fetchRequest)
            
            for item in moodObject {
                let id = item.value(forKey: "id") as? Int ?? -1
                let morning = item.value(forKey: "morning") as? String ?? ""
                let afternoon = item.value(forKey: "afternoon") as? String ?? ""
                let evening = item.value(forKey: "evening") as? String ?? ""
                let date = item.value(forKey: "date") as? Date ?? .distantFuture
                
                let moodItem = MoodItem(id: id, morning: morning, afternoon: afternoon, evening: evening, date: date)
                moodData.append(moodItem)
            }
            
            return moodData
            
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
        
        return moodData
    }
    
    func updateMood(mood: MoodItem) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Mood")
        fetchRequest.predicate = NSPredicate(format: "id == %d", mood.id)
        
        do {
            let notesObject = try viewContext.fetch(fetchRequest)
            
            if let item = notesObject.first {
                item.setValue(mood.morning, forKey: "morning")
                item.setValue(mood.afternoon, forKey: "afternoon")
                item.setValue(mood.evening, forKey: "evening")
            }
            
            try viewContext.save()
            
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
    }
    
    //Habits
    func saveHabit(habitItem: HabitItem) ->(Bool,String) {
        //check if exists, then put new start date else insert it afresh
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Habit")
        fetchRequest.predicate = NSPredicate(format: "id == %d", habitItem.id)
        
        do {
            let habitObject = try viewContext.fetch(fetchRequest)
           
            if let item = habitObject.first {
                item.setValue(false, forKey: "stop")
                try viewContext.save()
                
            } else {
                
                if let habitEntity = NSEntityDescription.entity(forEntityName: "Habit", in: viewContext){
                    let habitObject = NSManagedObject(entity: habitEntity, insertInto: viewContext)
                    habitObject.setValue(habitItem.id, forKey: "id")
                    habitObject.setValue(habitItem.title, forKey: "title")
                    habitObject.setValue(habitItem.image, forKey: "image")
                    habitObject.setValue(habitItem.backgroundColor, forKey: "backgroundColor")
                    habitObject.setValue(habitItem.isQuit, forKey: "isQuit")
                    habitObject.setValue(habitItem.habitFrequency.rawValue, forKey: "frequency")
                    habitObject.setValue(false, forKey: "stop")
                }
                
                if viewContext.hasChanges {
                    do {
                        try viewContext.save()
                    } catch let error as NSError {
                        print("Error: \(error.localizedDescription)")
                        return(false, error.localizedDescription)
                    }
                }
               
            }
            
            return(true, "Saved")
            
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
            return(false, error.localizedDescription)
        }
    
    }
    
    func updateHabit(habitItem: HabitItem) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Habit")
        fetchRequest.predicate = NSPredicate(format: "id == %d", habitItem.id)
        
        do {
            let habitObject = try viewContext.fetch(fetchRequest)
            
            if let item = habitObject.first {
                item.setValue(habitItem.title, forKey: "title")
                item.setValue(habitItem.image, forKey: "image")
                item.setValue(habitItem.backgroundColor, forKey: "backgroundColor")
                item.setValue(habitItem.isQuit, forKey: "isQuit")
                item.setValue(habitItem.habitFrequency.rawValue, forKey: "frequency")
               
                try viewContext.save()
                
            }
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
           
        }
    }
    
    func getHabits(date: Date) -> [HabitItem] {
        var habits: [HabitItem] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Habit")
        fetchRequest.predicate = NSPredicate(format: "stop == %d", false)
       
        do {
            let habitObject = try viewContext.fetch(fetchRequest)
            for item in habitObject {
                let id = item.value(forKey: "id") as? Int ?? -1
                let title = item.value(forKey: "title") as? String ?? ""
                let image = item.value(forKey: "image") as? String ?? ""
                let backgroundColor = item.value(forKey: "backgroundColor") as? String ?? ""
                let isQuit = item.value(forKey: "isQuit") as? Bool ?? false
                let frequency = item.value(forKey: "frequency") as? String ?? ""
 //               let stop = item.value(forKey: "stop") as? Bool ?? false
                
                
                let isChecked = checkHabitTracked(id: id, date: date)
                
                let trackCount = habitTrackCount(id: id, date: date)
                
                let habit = HabitItem(id: id, image: image, title: title, isQuit: isQuit, backgroundColor: backgroundColor, habitFrequency: frequency == "Daily" ? .daily : .weekly, isChecked: isChecked, trackCount: trackCount)
                habits.append(habit)
                
//                if ((Calendar.current.isDateInToday(date) || date > Date.now) && !stop) {
//                    habits.append(habit)
//                } else if (!(Calendar.current.isDateInToday(date) || date > Date.now) && isChecked || !stop){
//                    habits.append(habit)
//                }
                
            }
            
            return habits
            
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
        
        return habits
    }
    
    func stopHabit(id: Int) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Habit")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let habitObject = try viewContext.fetch(fetchRequest)
           
            if let item = habitObject.first {
                item.setValue(true, forKey: "stop")
            }
            
            try viewContext.save()
            
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
    }
    
    func trackHabit(id: Int, date: Date) {
        if let habitTrackEntity = NSEntityDescription.entity(forEntityName: "HabitTrack", in: viewContext) {
            let habitObject = NSManagedObject(entity: habitTrackEntity, insertInto: viewContext)
            habitObject.setValue(id, forKey: "id")
            habitObject.setValue(date, forKey: "date")
        }
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
               
            }
        }
    }
    
    func checkHabitTracked(id: Int,date: Date) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "HabitTrack")
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
       
        fetchRequest.predicate = NSPredicate(format: "id == %d AND date >= %@ AND date < %@", argumentArray: [id, startDate, endDate])
        
        do {
            let userObject =  try viewContext.fetch(fetchRequest)
            
            if userObject.count > 0 {
                return true
            }
            
            return false
            
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
        
        return false
    }
    
    func getTrackedHabits(id: Int, date: Date, frequency: Frequency) -> [Date] {
        var tracked: [Date] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "HabitTrack")
        
        if frequency == .monthly {
           let startDate = getThisMonthStart(date: date)
           let endDate = getThisMonthEnd(date: date)
           fetchRequest.predicate = NSPredicate(format: "id == %d AND date > %@ AND date <= %@", argumentArray: [id, startDate, endDate])
       } else if frequency == .yearly {
           let startDate = getThisYearStart(date: date)
           let endDate = getThisYearEnd(date: date)
           fetchRequest.predicate = NSPredicate(format: "id == %d AND date > %@ AND date <= %@", argumentArray: [id, startDate, endDate])
       }
        
        do {
            let trackedObject =  try viewContext.fetch(fetchRequest)
           
            for item in trackedObject {
                let date = item.value(forKey: "date") as? Date ?? .distantFuture
                tracked.append(date)
            }
            return tracked
            
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
        
        return tracked
    }
    
    func habitTrackCount(id: Int, date: Date, frequency: Frequency = .daily) -> Int {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "HabitTrack")
        let calendar = Calendar.current
        
        if frequency == .daily {
            let startDate = calendar.startOfDay(for: date)
            let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
            fetchRequest.predicate = NSPredicate(format: "id == %d AND date <= %@", argumentArray: [id, endDate])
        } else if frequency == .monthly {
           let startDate = getThisMonthStart(date: date)
           let endDate = getThisMonthEnd(date: date)
           fetchRequest.predicate = NSPredicate(format: "id == %d AND date > %@ AND date <= %@", argumentArray: [id, startDate, endDate])
       } else if frequency == .yearly {
           let startDate = getThisYearStart(date: date)
           let endDate = getThisYearEnd(date: date)
           fetchRequest.predicate = NSPredicate(format: "id == %d AND date > %@ AND date <= %@", argumentArray: [id, startDate, endDate])
       }
        
        do {
            let userObject =  try viewContext.fetch(fetchRequest)
            
            return  userObject.count

        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
        
        return 0
    }
    
    func getHabitData(date: Date, frequency: Frequency) -> [HabitItem] {
        var habits: [HabitItem] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Habit")
       // fetchRequest.predicate = NSPredicate(format: "stop == %d", false)
       
        do {
            let habitObject = try viewContext.fetch(fetchRequest)
            for item in habitObject {
                let id = item.value(forKey: "id") as? Int ?? -1
                let title = item.value(forKey: "title") as? String ?? ""
                let image = item.value(forKey: "image") as? String ?? ""
                let backgroundColor = item.value(forKey: "backgroundColor") as? String ?? ""
                let isQuit = item.value(forKey: "isQuit") as? Bool ?? false
                let habitFrequency = item.value(forKey: "frequency") as? String ?? ""
                
                let trackDates: [Date] = getTrackedHabits(id: id, date: date, frequency: frequency)
                let trackCount = trackDates.count
                let streak = checkStreak(of: trackDates)
                
                let completion: Double = Double(trackCount)/21.0 * 100
                
                
                if(trackCount > 0) {
                    
                    let habit = HabitItem(id: id, image: image, title: title, isQuit: isQuit, backgroundColor: backgroundColor, habitFrequency: habitFrequency == "Daily" ? .daily : .weekly, isChecked: true, trackCount: trackCount, trackDates: trackDates, completion: String(format: "%.0f", completion)+"%", currentStreak: streak.current, longestStreak: streak.longest)
                    
                    habits.append(habit)
                }
                
            }
            
            return habits
            
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
        
        return habits
    }
    
   
    //Gratitude
    
    func saveGratitude(gratitude: GratitudeItem) {
        if let gratitudeEntity = NSEntityDescription.entity(forEntityName: "Gratitude", in: viewContext){
            let gratitudeObject = NSManagedObject(entity: gratitudeEntity, insertInto: viewContext)
            gratitudeObject.setValue(gratitude.id, forKey: "id")
            gratitudeObject.setValue(gratitude.detail, forKey: "detail")
            gratitudeObject.setValue(gratitude.icon, forKey: "icon")
            gratitudeObject.setValue(gratitude.responsible, forKey: "responsible")
            gratitudeObject.setValue(gratitude.date, forKey: "date")
        }
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getGratitude(date: Date) -> [GratitudeItem] {
        var gratitudes: [GratitudeItem] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Gratitude")
        let startDate = getThisMonthStart(date: date)
        let endDate = getThisMonthEnd(date: date)
        let predicate = NSPredicate(format: "date > %@ AND date <= %@", argumentArray: [startDate, endDate])
        fetchRequest.predicate = predicate
        
        do {
            let gratitudeObject = try viewContext.fetch(fetchRequest)
            
            for item in gratitudeObject {
                let id = item.value(forKey: "id") as? Int ?? -1
                let detail = item.value(forKey: "detail") as? String ?? ""
                let icon = item.value(forKey: "icon") as? String ?? ""
                let responsible = item.value(forKey: "responsible") as? String ?? ""
                let date = item.value(forKey: "date") as? Date ?? .distantFuture
                
                let gratitudeItem = GratitudeItem(id: id, detail: detail, responsible: responsible, icon: icon, date: date)
                
                gratitudes.append(gratitudeItem)
            }
            
            return gratitudes
            
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
        
        return gratitudes
        
    }
    
    func updateGratitude(gratitudeItem: GratitudeItem) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Gratitude")
        fetchRequest.predicate = NSPredicate(format: "id == %d", gratitudeItem.id)
        
        do {
            let gratitudeObject = try viewContext.fetch(fetchRequest)
            
            if let item = gratitudeObject.first {
                item.setValue(gratitudeItem.detail, forKey: "detail")
                item.setValue(gratitudeItem.icon, forKey: "icon")
                item.setValue(gratitudeItem.responsible, forKey: "responsible")
                try viewContext.save()
            }
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
    }
    
    func deleteGratitude(id:Int) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Gratitude")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let gratitudeObject = try viewContext.fetch(fetchRequest)
            if let item = gratitudeObject.first {
                viewContext.delete(item)
            }
            try viewContext.save()
            
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
    }
    
    //Reminders
    func saveReminder(reminder: ReminderItem) {
        if let reminderEntity = NSEntityDescription.entity(forEntityName: "Reminders", in: viewContext){
            let reminderObject = NSManagedObject(entity: reminderEntity, insertInto: viewContext)
            reminderObject.setValue(reminder.id, forKey: "id")
            reminderObject.setValue(reminder.title, forKey: "title")
            reminderObject.setValue(reminder.time, forKey: "time")
        }
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getReminders() -> [ReminderItem] {
        var reminders: [ReminderItem] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Reminders")
        do {
            let reminderObject = try viewContext.fetch(fetchRequest)
            
            for item in reminderObject {
                let id = item.value(forKey: "id") as? Int ?? -1
                let title = item.value(forKey: "title") as? String ?? ""
                let time = item.value(forKey: "time") as? Date ?? .distantFuture
                let reminderItem = ReminderItem(id: id, title: title, time: time)
                reminders.append(reminderItem)
            }
            
            return reminders
            
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
        
        return reminders
        
    }
    
    func updateReminder(reminderItem: ReminderItem) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Reminders")
        fetchRequest.predicate = NSPredicate(format: "id == %d", reminderItem.id)
        
        do {
            let gratitudeObject = try viewContext.fetch(fetchRequest)
            
            if let item = gratitudeObject.first {
                item.setValue(reminderItem.title, forKey: "title")
                item.setValue(reminderItem.time, forKey: "time")
                try viewContext.save()
            }
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
    }
    
    func deleteReminder(id:Int) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Reminders")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let reminderObject = try viewContext.fetch(fetchRequest)
            if let item = reminderObject.first {
                viewContext.delete(item)
            }
            try viewContext.save()
            
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
    }
    
    
    // This Month Start
    func getThisMonthStart(date: Date) -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        return Calendar.current.date(from: components)!
    }
   //This months end
    func getThisMonthEnd(date: Date) -> Date {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: date) as NSDateComponents
        components.month += 1
        components.day = 1
        return Calendar.current.date(from: components as DateComponents)!
    }
    
    // This Year Start
    func getThisYearStart(date: Date) -> Date {
        let components = Calendar.current.dateComponents([.year], from: date)
        return Calendar.current.date(from: components)!
    }
   //This year End
    func getThisYearEnd(date: Date) -> Date {
        let components:NSDateComponents = Calendar.current.dateComponents([.year], from: date) as NSDateComponents
        components.year += 1
        return Calendar.current.date(from: components as DateComponents)!
    }
    func checkStreak(of dateArray: [Date]) -> (current: Int, longest: Int) {
        let dates = dateArray.sorted()
        // Check if the array contains more than 0 dates, otherwise return 0
        guard dates.count > 0 else { return (0,0) }
        // Get full day value of first date in array
        let referenceDate = Calendar.current.startOfDay(for: dates.first!)
        // Get an array of (non-decreasing) integers
        let dayDiffs = dates.map { (date) -> Int in
            Calendar.current.dateComponents([.day], from: referenceDate, to: date).day!
        }
        // Return max streak
        return maximalConsecutiveNumbers(in: dayDiffs)
    }


    // Find maximal length of a subsequence of consecutive numbers in the array.
    // It is assumed that the array is sorted in non-decreasing order.
    // Consecutive equal elements are ignored.

    func maximalConsecutiveNumbers(in array: [Int]) -> (Int,Int){
        var longest = 0 // length of longest subsequence of consecutive numbers
        var current = 1 // length of current subsequence of consecutive numbers

        for (prev, next) in zip(array, array.dropFirst()) {
            if next > prev + 1 {
                // Numbers are not consecutive, start a new subsequence.
                current = 1
            } else if next == prev + 1 {
                // Numbers are consecutive, increase current length
                current += 1
            }
            if current > longest {
                longest = current
            }
        }
        if current > longest {
            longest = current
        }
        return (current, longest)
    }
    

}
