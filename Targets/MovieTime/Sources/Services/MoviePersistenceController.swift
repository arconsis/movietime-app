//
//  MoviePersistenceController.swift
//  MovieTime
//
//  Created by arconsis on 19.11.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import Foundation
import CoreData

struct MoviePersistenceController {
    
    let container = NSPersistentContainer(name: "MovieDataModel")
    
    init(inMemory: Bool = false) {
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext? = nil) {
        let context = context ?? container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error.localizedDescription)")
            }
        }
    }
    
//    func perform(action: @escaping (NSManagedObjectContext) -> Void) {
//        container.performBackgroundTask { context in
//            action(context)
//            save(context: context)
//        }
//    }
}
