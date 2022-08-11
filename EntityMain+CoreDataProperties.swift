//
//  EntityMain+CoreDataProperties.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 11.08.2022.
//
//

import Foundation
import CoreData


extension EntityMain {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EntityMain> {
        return NSFetchRequest<EntityMain>(entityName: "EntityMain")
    }

    @NSManaged public var room: UUID?
    @NSManaged public var box: UUID?
    @NSManaged public var thing: UUID?
    @NSManaged public var toRoom: NSSet?
    @NSManaged public var toBox: NSSet?
    @NSManaged public var toThing: NSSet?

}

// MARK: Generated accessors for toRoom
extension EntityMain {

    @objc(addToRoomObject:)
    @NSManaged public func addToToRoom(_ value: EntityRooms)

    @objc(removeToRoomObject:)
    @NSManaged public func removeFromToRoom(_ value: EntityRooms)

    @objc(addToRoom:)
    @NSManaged public func addToToRoom(_ values: NSSet)

    @objc(removeToRoom:)
    @NSManaged public func removeFromToRoom(_ values: NSSet)

}

// MARK: Generated accessors for toBox
extension EntityMain {

    @objc(addToBoxObject:)
    @NSManaged public func addToToBox(_ value: EntityBoxs)

    @objc(removeToBoxObject:)
    @NSManaged public func removeFromToBox(_ value: EntityBoxs)

    @objc(addToBox:)
    @NSManaged public func addToToBox(_ values: NSSet)

    @objc(removeToBox:)
    @NSManaged public func removeFromToBox(_ values: NSSet)

}

// MARK: Generated accessors for toThing
extension EntityMain {

    @objc(addToThingObject:)
    @NSManaged public func addToToThing(_ value: EntityThings)

    @objc(removeToThingObject:)
    @NSManaged public func removeFromToThing(_ value: EntityThings)

    @objc(addToThing:)
    @NSManaged public func addToToThing(_ values: NSSet)

    @objc(removeToThing:)
    @NSManaged public func removeFromToThing(_ values: NSSet)

}

extension EntityMain : Identifiable {

}
