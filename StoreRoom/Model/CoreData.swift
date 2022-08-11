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
    func saveObject(objectForSave: Object, base: Bases, boxOrRoom: NSManagedObject) {
                switch base {
                case .boxs:
                    let object = NSEntityDescription.insertNewObject(forEntityName: base.rawValue,
                                                                     into: context) as! EntityBoxs
                    object.name = objectForSave.name
                    object.image = objectForSave.imageData
                    object.imageSmall = objectForSave.imageDataSmall
                    object.boxToRoom = boxOrRoom as? EntityRooms
                    object.id = UUID()
                    
                case .rooms, .main:
                    return
                case .things:
                    let object = NSEntityDescription.insertNewObject(forEntityName: base.rawValue,
                                                                     into: context) as! EntityThings
                    object.name = objectForSave.name
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
    
///find object by name or ID
    func findObjectByNameOrID(name: String?, id: UUID = UUID(), base: Bases) -> [NSManagedObject]?{
        var predicate: NSPredicate?
        if name != nil {predicate = NSPredicate(format: "name like %@", name!)}
            else{predicate = NSPredicate(format: "id == %@", id as CVarArg)}
        if let fetchResults = try? fetchContext(base: base, predicate: predicate){
            return fetchResults
//            switch base {
//            case .boxs:
//                return fetchResults as? [EntityBoxs]
//            case .rooms:
//                return fetchResults as? [EntityRooms]
//            case .things:
//                return fetchResults as? [EntityThings]
//            case .main:
//                return fetchResults as? [EntityMain]
//            }
            
        }
        else{
            return nil
        }
    }
    
///содержимое коробки или кладовки
    func contentBox(base: Bases, id: UUID) -> [NSManagedObject]?{
        var key:String = ""
        if let objectBox = findObjectByNameOrID(name: nil, id: id, base: base), objectBox.count == 1 {
            switch base {
            case .boxs:
                key = "boxToThing"
            case .rooms:
                key = "roomToThing"
            case .things, .main:
                break
            }
            let result = objectBox[0].value(forKey: key) as! [NSManagedObject]
            return result
        }
        return nil
    }
  
}


extension EntityRooms {
    func convertToItemCollection() -> ItemCollection{
        return ItemCollection(name: self.name, image: UIImage(data: self.image!)!, id: self.id)
    }
}

extension EntityBoxs {
    func convertToItemCollection() -> ItemCollection{
        return ItemCollection(name: self.name, image: UIImage(data: self.image!)!, id: self.id)
    }
}

extension EntityThings {
    func convertToItemCollection() -> ItemCollection{
        return ItemCollection(name: self.name, image: UIImage(data: self.image!)!, id: self.id)
    }
}
