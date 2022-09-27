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
    func getBoxs () -> [EntityBoxs]?
    func getRooms () -> [EntityRooms]?
    func getObjectBoxOrRoom () -> NSManagedObject
}

class GetDataInRoom: DataManager {

    var roomEntity: EntityRooms
    
    init (roomEntity: EntityRooms) {
        self.roomEntity = roomEntity
    }
    
    func getObjectBoxOrRoom() -> NSManagedObject {
        return roomEntity
    }
    
    func getRooms() -> [EntityRooms]? {
        return nil
    }
    
    func getThings() -> [EntityThings]? {
        let things = roomEntity.roomToThing
        return things?.allObjects as? [EntityThings]
    }
    
    func getBoxs() -> [EntityBoxs]? {
        let boxs = roomEntity.roomToBox
        return boxs?.allObjects as? [EntityBoxs]
    }
}


class GetDataInBox: DataManager {
    public var boxEntity: EntityBoxs
    
    init (boxEntity: EntityBoxs) {
        self.boxEntity = boxEntity
    }
    
    func getObjectBoxOrRoom() -> NSManagedObject {
        return boxEntity
    }
    
    func getRooms() -> [EntityRooms]? {
        return nil
    }
    
    func getThings() -> [EntityThings]? {
        let things = boxEntity.boxToThing
        return things?.allObjects as? [EntityThings]
    }
    
    func getBoxs() -> [EntityBoxs]? {
        return nil
    }
}
    
class GetRooms: DataManager {
    
    func getRooms() -> [EntityRooms]? {
        return try? BaseCoreData.shared.fetchContext(base: .rooms, predicate: nil).compactMap{$0 as? EntityRooms}
    }
    
    func getThings() -> [EntityThings]? {
        return nil
    }
    
    func getBoxs() -> [EntityBoxs]? {
        return nil
    }
    
    func getObjectBoxOrRoom() -> NSManagedObject {
        return EntityRooms()
    }
    
    
}
