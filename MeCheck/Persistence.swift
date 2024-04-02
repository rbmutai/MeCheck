//
//  Persistence.swift
//  MeCheck
//
//  Created by Robert Mutai on 23/02/2024.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

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
            let notesObject = try viewContext.fetch(fetchRequest)
            for item in notesObject {
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
    
    func habitTrackCount(id: Int, date: Date) -> Int {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "HabitTrack")
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
       
        fetchRequest.predicate = NSPredicate(format: "id == %d AND date <= %@", argumentArray: [id, endDate])
        
        do {
            let userObject =  try viewContext.fetch(fetchRequest)
            
            return  userObject.count

        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
        
        return 0
    }

}
