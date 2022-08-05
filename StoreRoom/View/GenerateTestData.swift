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

class TestData {
    let rooms = [Object(name: "Кладовка1", image: #imageLiteral(resourceName: "1.jpg")),
                 Object(name: "Кладовка2", image: #imageLiteral(resourceName: "2.jpg")),
                 Object(name: "Гараж", image: #imageLiteral(resourceName: "3.jpg")),
                 Object(name: "Шкаф", image: #imageLiteral(resourceName: "4.jpg"))]
    
    let boxs = [Object(name: "Коробка", image: #imageLiteral(resourceName: "box1.jpg")),
                Object(name: "Контейнер", image: #imageLiteral(resourceName: "box2.jpg")),
                Object(name: "Коробка2", image: #imageLiteral(resourceName: "box3.jpg")),
                Object(name: "Контейнер с игрушками", image: #imageLiteral(resourceName: "box4.jpg"))]
    
    let things = [Object(name: "босоножки", image: #imageLiteral(resourceName: "shoes5.jpg")),
                  Object(name: "туфли", image: #imageLiteral(resourceName: "shoes6.jpg")),
                  Object(name: "футболка", image: #imageLiteral(resourceName: "футболка.jpeg")),
                  Object(name: "Лопата", image: #imageLiteral(resourceName: "лопата.jpg")),
                  Object(name: "Каска", image: #imageLiteral(resourceName: "каска.jpg")),
                  Object(name: "Мангал", image: #imageLiteral(resourceName: "мангал.jpg")),
                  Object(name: "Свитер", image: #imageLiteral(resourceName: "свитер.jpg")),
                  Object(name: "сумка", image: #imageLiteral(resourceName: "сумка.jpg")),
                  Object(name: "Джинсы", image: #imageLiteral(resourceName: "джинсы.jpeg")),
                  Object(name: "toy1", image: #imageLiteral(resourceName: "toy1.jpg")),
                  Object(name: "toy2", image: #imageLiteral(resourceName: "toy2.jpg"))]
    let base = BaseCoreData()
    
    init(){
        
    }
    
///чистим всю базу
    func clearBase(){
        base.deleteAllCoreBases()
        debugPrint("base is clear")
    }
    
    ///Сохраняем кладовки
    func saveRoom(){
        for room in rooms{
            base.saveObject(objectForSave: room, base: .rooms)
        }
        debugPrint("saved rooms...")
    }
    
    ///Сохраняем ящики
    func saveBox(){
        do {
            let roomsObject = try base.fetchContext(base: .rooms, predicate: nil)
            if !roomsObject.isEmpty{
                for box in boxs{
                    base.saveObject(objectForSave: box, base: .boxs, boxOrRoom: roomsObject.randomElement()!)
                }
            }
            else{
                showMessage(message: #function + "result fetch is null")
            }
        }
        catch {
            showMessage(message: ValidationError.failedSaveOrder.localizedDescription)
        }
        debugPrint("saved boxs...")
    }

    func saveThing(){
        do {
            let roomsObject = try base.fetchContext(base: .rooms, predicate: nil)
            let boxObject = try base.fetchContext(base: .boxs, predicate: nil)
            if !roomsObject.isEmpty || !boxObject.isEmpty{
                for thing in things{
                    base.saveObject(objectForSave: thing, base: .things,
                                    boxOrRoom:  Bool.random() ? roomsObject.randomElement()! : boxObject.randomElement()!)
                }
            }
            else{
                showMessage(message: #function + "result fetch is null")
            }
        }
        catch {
            showMessage(message: ValidationError.failedSaveOrder.localizedDescription)
        }
        debugPrint("saved things...")
    }
    
}
