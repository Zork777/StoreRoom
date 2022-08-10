//
//  EntityThings+CoreDataClass.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 08.08.2022.
//
//

import Foundation
import CoreData
import UIKit

@objc(EntityThings)
public class EntityThings: NSManagedObject {
    func convertToItemCollection() -> ItemCollection{
        return ItemCollection(name: self.name ?? "-", image: UIImage(data: self.image!)!)
    }
}
