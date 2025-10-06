//
//  Place+CoreDataProperties.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 05/10/25.
//
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var address: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: Int16
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var sharedPlaces: NSSet?

}

// MARK: Generated accessors for sharedPlaces
extension Place {

    @objc(addSharedPlacesObject:)
    @NSManaged public func addToSharedPlaces(_ value: SharedPlaces)

    @objc(removeSharedPlacesObject:)
    @NSManaged public func removeFromSharedPlaces(_ value: SharedPlaces)

    @objc(addSharedPlaces:)
    @NSManaged public func addToSharedPlaces(_ values: NSSet)

    @objc(removeSharedPlaces:)
    @NSManaged public func removeFromSharedPlaces(_ values: NSSet)

}

extension Place : Identifiable {

}
