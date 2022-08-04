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
                  Object(name: "Джинсы", image: #imageLiteral(resourceName: "джинсы.jpeg"))]
    let base = BaseCoreData()
    
    init(){
        saveData()
    }
    
    func saveData(){
        for thing in things{
            base.saveObject(objectForSave: thing, base: .things)
        }
    }

}
