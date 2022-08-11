//
//  EntityThings+CoreDataProperties.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 11.08.2022.
//
//

import Foundation
import CoreData


extension EntityThings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EntityThings> {
        return NSFetchRequest<EntityThings>(entityName: "EntityThings")
    }

    @NSManaged public var image: Data?
    @NSManaged public var imageSmall: Data?
    @NSManaged public var name: String
    @NSManaged public var id: UUID
    @NSManaged public var thingToBox: EntityBoxs?
    @NSManaged public var thingToRoom: EntityRooms?
    @NSManaged public var toMain: NSSet?

}

// MARK: Generated accessors for toMain
extension EntityThings {

    @objc(addToMainObject:)
    @NSManaged public func addToToMain(_ value: EntityMain)

    @objc(removeToMainObject:)
    @NSManaged public func removeFromToMain(_ value: EntityMain)

    @objc(addToMain:)
    @NSManaged public func addToToMain(_ values: NSSet)

    @objc(removeToMain:)
    @NSManaged public func removeFromToMain(_ values: NSSet)

}

extension EntityThings : Identifiable {

}
