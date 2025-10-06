//
//  User+CoreDataProperties.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 05/10/25.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var avatarPath: String?
    @NSManaged public var id: Int16
    @NSManaged public var phone: String?
    @NSManaged public var username: String?
    @NSManaged public var membership: NSSet?
    @NSManaged public var sharedPlaces: NSSet?

}

// MARK: Generated accessors for membership
extension User {

    @objc(addMembershipObject:)
    @NSManaged public func addToMembership(_ value: Membership)

    @objc(removeMembershipObject:)
    @NSManaged public func removeFromMembership(_ value: Membership)

    @objc(addMembership:)
    @NSManaged public func addToMembership(_ values: NSSet)

    @objc(removeMembership:)
    @NSManaged public func removeFromMembership(_ values: NSSet)

}

// MARK: Generated accessors for sharedPlaces
extension User {

    @objc(addSharedPlacesObject:)
    @NSManaged public func addToSharedPlaces(_ value: SharedPlaces)

    @objc(removeSharedPlacesObject:)
    @NSManaged public func removeFromSharedPlaces(_ value: SharedPlaces)

    @objc(addSharedPlaces:)
    @NSManaged public func addToSharedPlaces(_ values: NSSet)

    @objc(removeSharedPlaces:)
    @NSManaged public func removeFromSharedPlaces(_ values: NSSet)

}

extension User : Identifiable {

}
