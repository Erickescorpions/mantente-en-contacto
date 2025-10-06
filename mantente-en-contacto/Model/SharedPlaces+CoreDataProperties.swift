//
//  SharedPlaces+CoreDataProperties.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 05/10/25.
//
//

import Foundation
import CoreData


extension SharedPlaces {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SharedPlaces> {
        return NSFetchRequest<SharedPlaces>(entityName: "SharedPlaces")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var id: Int16
    @NSManaged public var group: Group?
    @NSManaged public var place: Place?
    @NSManaged public var sharedBy: User?

}

extension SharedPlaces : Identifiable {

}
