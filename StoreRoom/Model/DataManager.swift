//
//  GetDataRoom.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 23.09.2022.
//

import Foundation

protocol DataManager {
    func getThings () -> [EntityThings]?
    func getBoxs () -> [EntityBoxs]?
    func getRooms () -> [EntityRooms]?
}

class GetDataInRoom: DataManager {
    var objectRoom: EntityRooms
    
    init (objectRoom: EntityRooms) {
        self.objectRoom = objectRoom
    }
    
    func getRooms() -> [EntityRooms]? {
        return nil
    }
    
    func getThings() -> [EntityThings]? {
        let things = objectRoom.roomToThing
        return things?.allObjects as? [EntityThings]
    }
    
    func getBoxs() -> [EntityBoxs]? {
        let boxs = objectRoom.roomToBox
        return boxs?.allObjects as? [EntityBoxs]
    }
}


class GetDataInBox: DataManager {
    var boxEntity: EntityBoxs
    
    init (boxEntity: EntityBoxs) {
        self.boxEntity = boxEntity
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
    
    
}
