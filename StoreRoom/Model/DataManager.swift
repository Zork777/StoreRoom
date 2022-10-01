//
//  GetDataRoom.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 23.09.2022.
//

import Foundation
import CoreData

protocol DataManager {
    func getThings () -> [EntityThings]?
//    func getBoxs () -> [EntityBoxs]?
//    func getRooms () -> [EntityRooms]?
    func getBoxOrRomm <T: NSManagedObject> () -> [T]?
    func getObjectBoxOrRoom () -> NSManagedObject?
}

class GetData <T: NSManagedObject> : DataManager {
    
    var object: T?
    
    init (object: T?) {
        self.object = object
    }
    
    func getThings() -> [EntityThings]? {
        var returnValue: NSSet?
        if let object = self.object {
            switch object.entity.name {
            case BaseCoreData.Bases.rooms.rawValue:
                let room = object as! EntityRooms
                returnValue = room.roomToThing
            case BaseCoreData.Bases.boxs.rawValue:
                let box = object as! EntityBoxs
                returnValue = box.boxToThing
            case .some(_), .none:
                print ("nothing")
            }
            
            return returnValue?.allObjects as? [EntityThings]
        }
        return nil
    }
    
    func getBoxOrRomm <T> () -> [T]? {
        var returnValue: [T] = []
        if let object = self.object {
            switch object.entity.name {
            case BaseCoreData.Bases.rooms.rawValue:
                let room = object as! EntityRooms
                returnValue = room.roomToBox?.allObjects as! [T]
            case BaseCoreData.Bases.boxs.rawValue:
                let box = object as! EntityBoxs
                returnValue = box.boxToBox?.allObjects as! [T]
            case .some(_), .none:
                print ("nothing")
            }
            
            return returnValue
        }
        return try? BaseCoreData.shared.fetchContext(base: .rooms, predicate: nil).compactMap{$0 as? T}
    }
    
    func getObjectBoxOrRoom() -> NSManagedObject? {
        if let object = object {
            return object
        }
        return nil
    }
    
    
}
//
//class GetDataInRoom: DataManager {
//
//    var roomEntity: EntityRooms
//    
//    init (roomEntity: EntityRooms) {
//        self.roomEntity = roomEntity
//    }
//    
//    func getObjectBoxOrRoom() -> NSManagedObject? {
//        return roomEntity
//    }
//    
//    func getBoxOrRomm <T: NSManagedObject> () -> [T]? {
//        return nil
//    }
//    
//    func getRooms() -> [EntityRooms]? {
//        return nil
//    }
//    
//    func getThings() -> [EntityThings]? {
//        let things = roomEntity.roomToThing
//        return things?.allObjects as? [EntityThings]
//    }
//    
//    func getBoxs() -> [EntityBoxs]? {
//        return nil
//    }
//}
//
//
//class GetDataInBox: DataManager {
//    public var boxEntity: EntityBoxs
//    
//    init (boxEntity: EntityBoxs) {
//        self.boxEntity = boxEntity
//    }
//    
//    func getBoxOrRomm <T: NSManagedObject> () -> [T]? {
//
//        return nil
//    }
//    
//    func getObjectBoxOrRoom() -> NSManagedObject? {
//        return boxEntity
//    }
//    
//    func getRooms() -> [EntityRooms]? {
//        return nil
//    }
//    
//    func getThings() -> [EntityThings]? {
//        let things = boxEntity.boxToThing
//        return things?.allObjects as? [EntityThings]
//    }
//    
//    func getBoxs() -> [EntityBoxs]? {
//        let boxs = boxEntity.boxToBox
//        return boxs?.allObjects as? [EntityBoxs]
//    }
//}
//    
//class GetRooms: DataManager {
//    
//    func getRooms() -> [EntityRooms]? {
//        return try? BaseCoreData.shared.fetchContext(base: .rooms, predicate: nil).compactMap{$0 as? EntityRooms}
//    }
//    
//    func getBoxOrRomm <T: NSManagedObject> () -> [T]? {
//        return nil
//    }
//    
//    func getThings() -> [EntityThings]? {
//        return nil
//    }
//    
//    func getBoxs() -> [EntityBoxs]? {
//        return nil
//    }
//    
//    func getObjectBoxOrRoom() -> NSManagedObject? {
//        return EntityRooms()
//    }
//    
//    
//}
