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
    }
    
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
    
    
    
}
