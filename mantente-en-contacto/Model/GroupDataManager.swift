//
//  GroupDataManager.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 24/08/25.
//

import CoreData

class GroupDataManager {
    private var groups: [Group] = []
    
    func getGroup(at index : Int) -> Group {
        return groups[index]
    }
    
    func count() -> Int {
        return groups.count
    }
    
    func all() -> [Group] {
        let fetch: NSFetchRequest<Group> = Group.fetchRequest()
        let context = Connection.shared.persistentContainer.viewContext
        
        do {
            self.groups = try context.fetch(fetch)
            return self.groups
        } catch {
            return []
        }
    }
}
