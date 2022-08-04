//
//  CoreData.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 04.08.2022.
//

import Foundation
import CoreData


class BaseCoreData {
    let persistentContainer: NSPersistentContainer
    let context: NSManagedObjectContext
    
    ///Название  base
    enum Bases: String{
        case boxs = "EntityBoxs"
        case rooms = "EntityRooms"
        case things = "EntityThings"
        
//        func nameBase (base: Bases) -> AnyObject{
//            switch base {
//            case .rooms:
//                return EntityRooms.self
//            case .things:
//                return EntityThings.self
//            case .boxs:
//                return EntityBoxs.self
//            }
//        }
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
    
    func saveContext () throws{
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
    func saveObject(objectForSave: Object, base: Bases) {
//        var object: NSManagedObject
//        switch base {
//        case .boxs:
//            object = NSEntityDescription.insertNewObject(forEntityName: base.rawValue,
//                                                             into: context) as! EntityBoxs
//        case .rooms:
//            object = NSEntityDescription.insertNewObject(forEntityName: base.rawValue,
//                                                             into: context) as! EntityBoxs
//        case .things:
//            object = NSEntityDescription.insertNewObject(forEntityName: base.rawValue,
//                                                             into: context) as! EntityBoxs
//
//        }
        let object = NSEntityDescription.insertNewObject(forEntityName: base.rawValue, into: context)
        object.setValue(objectForSave.name, forKey: "name") //name = objectForSave.name
        object.setValue(objectForSave.image.jpegData(compressionQuality: 1), forKey: "image") //object.image = objectForSave.image.jpegData(compressionQuality: 1)
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

    
///запрос к  базе
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




