//
//  EntityRooms+CoreDataProperties.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 11.08.2022.
//
//

import Foundation
import CoreData


extension EntityRooms {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EntityRooms> {
        return NSFetchRequest<EntityRooms>(entityName: "EntityRooms")
    }

    @NSManaged public var image: Data?
    @NSManaged public var imageSmall: Data?
    @NSManaged public var name: String
    @NSManaged public var id: UUID
    @NSManaged public var roomToBox: NSSet?
    @NSManaged public var roomToThing: NSSet?
    @NSManaged public var toMain: NSSet?

}

// MARK: Generated accessors for roomToBox
extension EntityRooms {

    @objc(addRoomToBoxObject:)
    @NSManaged public func addToRoomToBox(_ value: EntityBoxs)

    @objc(removeRoomToBoxObject:)
    @NSManaged public func removeFromRoomToBox(_ value: EntityBoxs)

    @objc(addRoomToBox:)
    @NSManaged public func addToRoomToBox(_ values: NSSet)

    @objc(removeRoomToBox:)
    @NSManaged public func removeFromRoomToBox(_ values: NSSet)

}

// MARK: Generated accessors for roomToThing
extension EntityRooms {

    @objc(addRoomToThingObject:)
    @NSManaged public func addToRoomToThing(_ value: EntityThings)

    @objc(removeRoomToThingObject:)
    @NSManaged public func removeFromRoomToThing(_ value: EntityThings)

    @objc(addRoomToThing:)
    @NSManaged public func addToRoomToThing(_ values: NSSet)

    @objc(removeRoomToThing:)
    @NSManaged public func removeFromRoomToThing(_ values: NSSet)

}

// MARK: Generated accessors for toMain
extension EntityRooms {

    @objc(addToMainObject:)
    @NSManaged public func addToToMain(_ value: EntityMain)

    @objc(removeToMainObject:)
    @NSManaged public func removeFromToMain(_ value: EntityMain)

    @objc(addToMain:)
    @NSManaged public func addToToMain(_ values: NSSet)

    @objc(removeToMain:)
    @NSManaged public func removeFromToMain(_ values: NSSet)

}

extension EntityRooms : Identifiable {

}
