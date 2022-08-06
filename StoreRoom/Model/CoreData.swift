//
//  CoreData.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 04.08.2022.
//

import Foundation
import CoreData


class BaseCoreData {
    private let persistentContainer: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    ///Название  base
    enum Bases: String, CaseIterable{
        case boxs = "EntityBoxs"
        case rooms = "EntityRooms"
        case things = "EntityThings"
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

///Сохранение объекта в core
    func saveObject(objectForSave: Object, base: Bases) throws {
        let object = NSEntityDescription.insertNewObject(forEntityName: base.rawValue, into: context)
        object.setValue(objectForSave.name, forKey: "name") //name = objectForSave.name
        object.setValue(objectForSave.image.jpegData(compressionQuality: 1), forKey: "image") //object.image = objectForSave.image.jpegData(compressionQuality: 1)
        do {
            try self.saveContext()
        }
        catch{
            showMessage(message: error.localizedDescription)
            throw ValidationError.failedSavingInCoreData
        }
    }

    func saveObject(objectForSave: Object, base: Bases, boxOrRoom: NSManagedObject) {
                switch base {
                case .boxs:
                    let object = NSEntityDescription.insertNewObject(forEntityName: base.rawValue,
                                                                     into: context) as! EntityBoxs
                    object.name = objectForSave.name
                    object.image = objectForSave.image.jpegData(compressionQuality: 1)
                    object.boxToRoom = boxOrRoom as? EntityRooms
                case .rooms:
                    return
                case .things:
                    let object = NSEntityDescription.insertNewObject(forEntityName: base.rawValue,
                                                                     into: context) as! EntityThings
                    object.name = objectForSave.name
                    object.image = objectForSave.image.jpegData(compressionQuality: 1)
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
    
///find things by name
    func getThingsByName(name: String) -> [EntityThings]?{
        let predicate =  NSPredicate(format: "name == %@", name)
        if let fetchResults = try? fetchContext(base: .things, predicate: predicate){
            return fetchResults as? [EntityThings]
        }
        else{
            return nil
        }
    }
  
}




