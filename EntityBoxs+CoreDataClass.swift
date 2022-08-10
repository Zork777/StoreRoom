//
//  EntityBoxs+CoreDataClass.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 08.08.2022.
//
//

import Foundation
import CoreData
import UIKit

@objc(EntityBoxs)
public class EntityBoxs: NSManagedObject {
    func convertToItemCollection() -> ItemCollection{
        return ItemCollection(name: self.name ?? "-", image: UIImage(data: self.image!)!)
    }
}
