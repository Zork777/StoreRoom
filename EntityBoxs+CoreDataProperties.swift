//
//  EntityBoxs+CoreDataProperties.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 04.08.2022.
//
//

import Foundation
import CoreData


extension EntityBoxs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EntityBoxs> {
        return NSFetchRequest<EntityBoxs>(entityName: "EntityBoxs")
    }

    @NSManaged public var name: String?
    @NSManaged public var image: Data?
    @NSManaged public var boxToRoom: EntityRooms?
    @NSManaged public var boxToThing: NSSet?

}

// MARK: Generated accessors for boxToThing
extension EntityBoxs {

    @objc(addBoxToThingObject:)
    @NSManaged public func addToBoxToThing(_ value: EntityThings)

    @objc(removeBoxToThingObject:)
    @NSManaged public func removeFromBoxToThing(_ value: EntityThings)

    @objc(addBoxToThing:)
    @NSManaged public func addToBoxToThing(_ values: NSSet)

    @objc(removeBoxToThing:)
    @NSManaged public func removeFromBoxToThing(_ values: NSSet)

}

extension EntityBoxs : Identifiable {

}
