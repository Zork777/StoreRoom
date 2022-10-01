//
//  CoreData.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 04.08.2022.
//

import Foundation
import CoreData
import UIKit



class BaseCoreData {
    private let persistentContainer: NSPersistentContainer
    private let context: NSManagedObjectContext
    static let shared = BaseCoreData()
    
    ///Название  base
    enum Bases: String, CaseIterable{
        case boxs = "EntityBoxs"
        case rooms = "EntityRooms"
        case things = "EntityThings"
        case main = "EntityMain"
    }
    
    
    init (){
        persistentContainer = {
                  let container = NSPersistentContainer(name: "StoreRoom")
                  container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                      if let error = error as NSError? {
                          fatalError("Unresolved error \(error), \(error.userInfo)")
                      }
                  })
                  return container
            }()
        
        context = self.persistentContainer.viewContext
        }
    
   private func saveContext () throws{
          if context.hasChanges {
              do {
                  try context.save()
                  debugPrint ("saved in core data")
              } catch {
                  context.rollback()
                  let nserror = error as NSError
                  debugPrint ("Unresolved error \(nserror), \(nserror.userInfo)")
                  throw ValidationError.failedSavingInCoreData
              }
          }
      }

    
///Сохранение объекта в base core data
    func saveObject(objectForSave: Object, base: Bases) throws {
        let object = NSEntityDescription.insertNewObject(forEntityName: base.rawValue, into: context)
        object.setValue(objectForSave.name, forKey: "name")
        object.setValue(objectForSave.imageData, forKey: "image")
        object.setValue(objectForSave.imageDataSmall, forKey: "imageSmall")
        object.setValue(UUID(), forKey: "id")
        do {
            try self.saveContext()
        }
        catch{
            showMessage(message: error.localizedDescription)
            throw ValidationError.failedSavingInCoreData
        }
    }

///Сохранение объекта в core со связкой с коробкой или кладовкой
    func saveObject(objectForSave: Object, base: Bases, boxOrRoom: NSManagedObject) throws {
                switch base {
                case .boxs:
                    let object = NSEntityDescription.insertNewObject(forEntityName: base.rawValue,
                                                                     into: context) as! EntityBoxs
                    object.name = objectForSave.name ?? "_"
                    object.image = objectForSave.imageData
                    object.imageSmall = objectForSave.imageDataSmall
                    if boxOrRoom.entity.name == Bases.boxs.rawValue {
                        let boxEntity = boxOrRoom as! EntityBoxs
                        boxEntity.boxToBox = boxEntity.boxToBox?.adding(object) as NSSet?
                    }
                    else {
                        object.boxToRoom = boxOrRoom as? EntityRooms
                    }
                    
                    object.id = UUID()
                    
                case .rooms, .main:
                    return
                case .things:
                    let object = NSEntityDescription.insertNewObject(forEntityName: base.rawValue,
                                                                     into: context) as! EntityThings
                    object.name = objectForSave.name ?? "_"
                    object.image = objectForSave.imageData
                    object.imageSmall = objectForSave.imageDataSmall
                    object.id = UUID()
                    if boxOrRoom.entity.name == Bases.boxs.rawValue {
                        object.thingToBox = boxOrRoom as? EntityBoxs
                    }
                    else {
                        object.thingToRoom = boxOrRoom as? EntityRooms
                    }
        
                }
        do {
            try self.saveContext()
        }
        catch{
            showMessage(message: error.localizedDescription)
        }
    }
    
    
///удаление объекта из core
    func deleteObject(object: NSManagedObject) throws{
        do{
            context.delete(object)
            try context.save()
        }
        catch {
            throw ValidationError.failedDeleteInCoreData
        }
    }

    
///поисковый запрос к  базе
    func fetchContext (base: Bases, predicate: NSPredicate?) throws -> [NSManagedObject]{
        let entityDescription = NSEntityDescription.entity(forEntityName: base.rawValue, in: context)

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entityDescription
        
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        let objects = try context.fetch(fetchRequest)
        return objects as! [NSManagedObject]
    }
    
///удаление всей базы
    func deleteAllCoreBases() {
        let base = BaseCoreData()
        for baseName in Bases.allCases {
            do{
                try base.deleteContext(base: baseName, predicate: nil)
                try base.saveContext()
            }
            catch{
                showMessage(message: "fatal clear base \(baseName.rawValue)")
            }
        }
    }
    
///удаление по выборке
    func deleteContext (base: Bases, predicate: NSPredicate?) throws {
        do {
            let objects = try fetchContext(base: base, predicate: predicate)
            for object in objects {
                context.delete(object)
            }
            try context.save()
        }
        catch {
            throw ValidationError.failedDeleteInCoreData
        }
    }

///find object Box or Room in base
    func findBoxOrRoomByID(id: UUID) -> NSManagedObject?{
        guard let objectBoxOrRoom = findObjectByNameOrID(name: nil, id: id, base: .boxs)?.first else {
            guard let objectBoxOrRoom = findObjectByNameOrID(name: nil, id: id, base: .rooms)?.first else {
                return nil
            }
            return objectBoxOrRoom
        }
        return objectBoxOrRoom
    }
    
///find object by name or ID
    func findObjectByNameOrID(name: String?, id: UUID = UUID(), base: Bases) -> [NSManagedObject]?{
        var predicate: NSPredicate?
        if name != nil {predicate = NSPredicate(format: "name like %@", name!)}
            else{predicate = NSPredicate(format: "id == %@", id as CVarArg)}
        if let fetchResults = try? fetchContext(base: base, predicate: predicate){
            return fetchResults
        }
        else{
            return nil
        }
    }

    
///извлекаем все коробки в кладовке
    func getBoxInRoom(idRoom: UUID) -> [EntityBoxs]?{
        guard let objectRoom = findObjectByNameOrID(name: nil, id: idRoom, base: .rooms)?.first as? EntityRooms else {return nil}
        guard let content = objectRoom.roomToBox?.map({$0 as! EntityBoxs}) else {return nil}
        return content
    }
    
///содержимое коробки
    func getContentBox(idBox: UUID) -> [EntityThings]? {
        let objectBox = findObjectByNameOrID(name: nil, id: idBox, base: .boxs)?.first as? EntityBoxs
        if objectBox != nil {
            guard let content = objectBox!.boxToThing?.map({$0 as! EntityThings}) else {return nil}
            return content
        }
        return nil
    }
    
///содержимое кладовки
    func getContentRoom(idRoom: UUID) -> [EntityThings]?{
        let objectRoom = findObjectByNameOrID(name: nil, id: idRoom, base: .rooms)?.first as? EntityRooms
        if objectRoom != nil {
            guard let content = objectRoom!.roomToThing?.map({$0 as! EntityThings}) else {return nil}
            return content
        }
        return nil
    }
  
}


extension EntityRooms {
    func convertToItemCollection() -> CellData{
        return CellData(name: self.name, image: UIImage(data: self.image!)!)
    }
}

extension EntityBoxs {
    func convertToItemCollection() -> CellData{
        return CellData(name: self.name, image: UIImage(data: self.image!)!)
    }
}

extension EntityThings {
    func convertToItemCollection() -> CellData{
        return CellData(name: self.name, image: UIImage(data: self.image!)!)
    }
}

extension Data {
    func convertToUIImage() -> UIImage {
        guard let image = UIImage(data: self) else {return #imageLiteral(resourceName: "noPhoto")}
        return image
    }
}
