//
//  EntityThings+CoreDataClass.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 11.08.2022.
//
//

import Foundation
import CoreData

@objc(EntityThings)
public class EntityThings: NSManagedObject, Comparable {
    public static func < (lhs: EntityThings, rhs: EntityThings) -> Bool {
        return lhs.name > rhs.name
    }
    

}
