//
//  EntityBoxs+CoreDataProperties.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 28.09.2022.
//
//

import Foundation
import CoreData


extension EntityBoxs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EntityBoxs> {
        return NSFetchRequest<EntityBoxs>(entityName: "EntityBoxs")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var image: Data?
    @NSManaged public var imageSmall: Data?
    @NSManaged public var name: String
    @NSManaged public var boxToRoom: EntityRooms?
    @NSManaged public var boxToThing: NSSet?
    @NSManaged public var toMain: NSSet?
    @NSManaged public var boxToBox: NSSet?

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

// MARK: Generated accessors for toMain
extension EntityBoxs {

    @objc(addToMainObject:)
    @NSManaged public func addToToMain(_ value: EntityMain)

    @objc(removeToMainObject:)
    @NSManaged public func removeFromToMain(_ value: EntityMain)

    @objc(addToMain:)
    @NSManaged public func addToToMain(_ values: NSSet)

    @objc(removeToMain:)
    @NSManaged public func removeFromToMain(_ values: NSSet)

}

// MARK: Generated accessors for boxToBox
extension EntityBoxs {

    @objc(addBoxToBoxObject:)
    @NSManaged public func addToBoxToBox(_ value: EntityBoxs)

    @objc(removeBoxToBoxObject:)
    @NSManaged public func removeFromBoxToBox(_ value: EntityBoxs)

    @objc(addBoxToBox:)
    @NSManaged public func addToBoxToBox(_ values: NSSet)

    @objc(removeBoxToBox:)
    @NSManaged public func removeFromBoxToBox(_ values: NSSet)

}

extension EntityBoxs : Identifiable {

}
