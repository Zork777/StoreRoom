//
//  EntityThings+CoreDataProperties.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 08.08.2022.
//
//

import Foundation
import CoreData


extension EntityThings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EntityThings> {
        return NSFetchRequest<EntityThings>(entityName: "EntityThings")
    }

    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var imageSmall: Data?
    @NSManaged public var thingToBox: EntityBoxs?
    @NSManaged public var thingToRoom: EntityRooms?

}

extension EntityThings : Identifiable {

}
