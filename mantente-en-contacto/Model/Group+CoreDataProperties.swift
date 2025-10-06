//
//  Group+CoreDataProperties.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 05/10/25.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var members: NSSet?
    @NSManaged public var sharedPlaces: NSSet?

}

// MARK: Generated accessors for members
extension Group {

    @objc(addMembersObject:)
    @NSManaged public func addToMembers(_ value: Membership)

    @objc(removeMembersObject:)
    @NSManaged public func removeFromMembers(_ value: Membership)

    @objc(addMembers:)
    @NSManaged public func addToMembers(_ values: NSSet)

    @objc(removeMembers:)
    @NSManaged public func removeFromMembers(_ values: NSSet)

}

// MARK: Generated accessors for sharedPlaces
extension Group {

    @objc(addSharedPlacesObject:)
    @NSManaged public func addToSharedPlaces(_ value: SharedPlaces)

    @objc(removeSharedPlacesObject:)
    @NSManaged public func removeFromSharedPlaces(_ value: SharedPlaces)

    @objc(addSharedPlaces:)
    @NSManaged public func addToSharedPlaces(_ values: NSSet)

    @objc(removeSharedPlaces:)
    @NSManaged public func removeFromSharedPlaces(_ values: NSSet)

}

extension Group : Identifiable {

}
