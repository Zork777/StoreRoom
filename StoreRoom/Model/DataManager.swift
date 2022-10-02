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
    func getBoxOrRomm <T: NSManagedObject> () -> [T]?
    func getObjectBoxOrRoom () -> NSManagedObject?
    func saveObjectInBase(typeObjectForSave: BaseCoreData.Bases, objectForSave: Object) -> Bool
}

class GetData <T: NSManagedObject> : DataManager {
    
    var object: T? //храним родительский объект (коробка или кладовка)
    
    init (object: T?) {
        self.object = object
    }
    
    /// Получение вещей хранимые в объекте (родительский)
    /// - Returns: массив вещей
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

    
    /// Получаем коробки или кладовки
    /// - Returns: массив коробок или кладовок
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
    
    /// Получение вышестоящего объекта (родительского)
    /// - Returns: возвращаем объект
    func getObjectBoxOrRoom() -> NSManagedObject? {
        if let object = object {
            return object
        }
        return nil
    }

///сохранение вещи или коробки
    func saveObjectInBase(typeObjectForSave: BaseCoreData.Bases, objectForSave: Object) -> Bool {
        let boxOrRoom = self.getObjectBoxOrRoom()
        
        if boxOrRoom == nil && typeObjectForSave != .rooms {
            showMessage(message: "error save object")
            return false
        }
        
        switch typeObjectForSave {
        case .things:
            do {
                try BaseCoreData.shared.saveObject(objectForSave: objectForSave,
                                                   base: .things,
                                                   boxOrRoom: boxOrRoom!)
            }
            catch {
                showMessage(message: "error save object thing")
                return false
            }
            
        case .boxs:
            do {
                try BaseCoreData.shared.saveObject(objectForSave: objectForSave,
                                                   base: .boxs,
                                                   boxOrRoom: boxOrRoom!)
            }
            catch {
                showMessage(message: "error save object box")
                return false
            }
            
        case .rooms:
            do {
                try BaseCoreData.shared.saveObject(objectForSave: objectForSave,
                                                   base: .rooms)
            }
            catch {
                showMessage(message: "error save object room")
                return false
            }
            
        case .main:
            print ("type not found")
            return false
        }
        
        return true
    }
}
