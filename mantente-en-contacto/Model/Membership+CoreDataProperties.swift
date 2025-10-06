//
//  Membership+CoreDataProperties.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 05/10/25.
//
//

import Foundation
import CoreData


extension Membership {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Membership> {
        return NSFetchRequest<Membership>(entityName: "Membership")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var id: Int16
    @NSManaged public var group: Group?
    @NSManaged public var user: User?

}

extension Membership : Identifiable {

}
