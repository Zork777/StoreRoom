//
//  GenerateTestData.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 03.08.2022.
//

import Foundation
import UIKit


/*
 Генерируем тестовые данные и записываем в CoreData
 */

class TestData: BaseCoreData {
    var testRooms = [Object]()
    var testBoxs = [Object]()
    var testThings = [Object]()
    
    let testRoomsRu = [Object(name: "Кладовка1", image: #imageLiteral(resourceName: "noPhoto")),//UIImage( //named: "room1")!),
                 Object(name: "Кладовка2", image: #imageLiteral(resourceName: "noPhoto")),
                 Object(name: "Гараж", image: #imageLiteral(resourceName: "noPhoto")),
                 Object(name: "Шкаф", image: #imageLiteral(resourceName: "noPhoto"))]
    
    let testBoxsRu = [Object(name: "Коробка", image: #imageLiteral(resourceName: "noPhoto")),
                Object(name: "Контейнер", image: #imageLiteral(resourceName: "noPhoto")),
                Object(name: "Коробка2", image: #imageLiteral(resourceName: "noPhoto")),
                Object(name: "Контейнер с игрушками", image: #imageLiteral(resourceName: "noPhoto"))]
    
    let testThingsRu = [Object(name: "босоножки", image: #imageLiteral(resourceName: "noPhoto")),
                  Object(name: "туфли", image: #imageLiteral(resourceName: "noPhoto")),
                  Object(name: "футболка", image: #imageLiteral(resourceName: "noPhoto")),
                  Object(name: "Лопата", image: #imageLiteral(resourceName: "noPhoto")),
                  Object(name: "Каска", image: #imageLiteral(resourceName: "noPhoto")),
                  Object(name: "Мангал", image: #imageLiteral(resourceName: "noPhoto")),
                  Object(name: "Свитер", image: #imageLiteral(resourceName: "noPhoto")),
                  Object(name: "сумка", image: #imageLiteral(resourceName: "noPhoto")),
                  Object(name: "Джинсы", image: #imageLiteral(resourceName: "noPhoto")),
                  Object(name: "Стич", image: #imageLiteral(resourceName: "noPhoto")),
                  Object(name: "Игрушка", image: #imageLiteral(resourceName: "noPhoto"))]
    
    let testRoomsEn = [Object(name: "Storeroom1", image: #imageLiteral(resourceName: "noPhoto")),
                 Object(name: "Storeroom2", image: #imageLiteral(resourceName: "noPhoto")),
                 Object(name: "Garage", image: #imageLiteral(resourceName: "noPhoto")),
                 Object(name: "Wardrobe", image: #imageLiteral(resourceName: "noPhoto"))]
    
    let testBoxsEn = [Object(name: "Box", image: #imageLiteral(resourceName: "noPhoto")),
                Object(name: "Container", image: #imageLiteral(resourceName: "noPhoto")),
                Object(name: "Box2", image: #imageLiteral(resourceName: "noPhoto")),
                Object(name: "Container with toys", image: #imageLiteral(resourceName: "noPhoto"))]
    
    let testThingsEn = [Object(name: "sandals", image: #imageLiteral(resourceName: "noPhoto")),
                  Object(name: "shoes", image: #imageLiteral(resourceName: "noPhoto")),
                  Object(name: "T-shirt", image: #imageLiteral(resourceName: "noPhoto")),
                  Object(name: "Shovel", image: #imageLiteral(resourceName: "noPhoto")),
                  Object(name: "Helmet", image: #imageLiteral(resourceName: "noPhoto")),
                  Object(name: "Barbecue", image: #imageLiteral(resourceName: "noPhoto")),
                  Object(name: "Sweater", image: #imageLiteral(resourceName: "noPhoto")),
                  Object(name: "bag", image: #imageLiteral(resourceName: "noPhoto")),
                  Object(name: "Jeans", image: #imageLiteral(resourceName: "noPhoto")),
                  Object(name: "Stitch", image: #imageLiteral(resourceName: "noPhoto")),
                  Object(name: "toy", image: #imageLiteral(resourceName: "noPhoto"))]
    
    
    let base = BaseCoreData()
    
    override init(){
        super.init()

        if let languages = Locale.preferredLanguages.first, languages.contains("ru") {
            testRooms = testRoomsRu
            testBoxs = testBoxsRu
            testThings = testThingsRu
        }
        else {
            testRooms = testRoomsEn
            testBoxs = testBoxsEn
            testThings = testThingsEn
        }
    }
    
///чистим всю базу
    func clearBase(){
        base.deleteAllCoreBases()
        debugPrint("base is clear")
    }
    
    ///Сохраняем кладовки
    func saveTestRooms(){
        for room in testRooms{
            do{
                try base.saveObject(objectForSave: room, base: .rooms)
            }
            catch{
                showMessage(message: error.localizedDescription)
            }
        }
        debugPrint("saved rooms...")
    }
    
    ///Сохраняем ящики
    func saveTestBoxs(){
        do {
            let roomsObject = try base.fetchContext(base: .rooms, predicate: nil)
            if !roomsObject.isEmpty{
                for box in testBoxs{
                    do {
                        try base.saveObject(objectForSave: box, base: .boxs, boxOrRoom: roomsObject.randomElement()!)
                    }
                    catch {
                        showMessage(message: "Error save object")
                    }
                }
            }
            else{
                showMessage(message: #function + "result fetch is null")
            }
        }
        catch {
            showMessage(message: ValidationError.failedSavingInCoreData.localizedDescription)
        }
        debugPrint("saved boxs...")
    }

    func saveTestThings(){
        do {
            let roomsObject = try base.fetchContext(base: .rooms, predicate: nil)
            let boxObject = try base.fetchContext(base: .boxs, predicate: nil)
            if !roomsObject.isEmpty || !boxObject.isEmpty{
                for thing in testThings{
                    do {
                        try base.saveObject(objectForSave: thing, base: .things,
                                    boxOrRoom:  Bool.random() ? roomsObject.randomElement()! : boxObject.randomElement()!)
                    }
                    catch {
                        showMessage(message: "Error save Object")
                    }
                }
            }
            else{
                showMessage(message: #function + "result fetch is null")
            }
        }
        catch {
            showMessage(message: ValidationError.failedDeleteInCoreData.localizedDescription)
        }
        debugPrint("saved things...")
    }
    
}

