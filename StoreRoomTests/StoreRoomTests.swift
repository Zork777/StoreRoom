//
//  StoreRoomTests.swift
//  StoreRoomTests
//
//  Created by Евгений Захаров on 03.08.2022.
//

import XCTest
import CoreData
@testable import StoreRoom

class StoreRoomTests: XCTestCase {
    let testBase = TestData()
    var testThingToy: Object?
    var testThingHelmet: Object?
    var testThingShoes: Object?
    var testRoom: Object?
    var testBox: Object?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testBase.clearBase()
        testThingToy = testBase.testThings[9] //name: "toy1", image: "toy1.jpg"
        testThingShoes = testBase.testThings[0] //name: "Босоножки", image: #imageLiteral(resourceName: "shoes2.jpg")
        testThingHelmet = testBase.testThings[4] //name: "Каска", image: #imageLiteral(resourceName: "каска.jpg")
        testRoom = testBase.testRooms[0] //name: "Кладовка1", image: #imageLiteral(resourceName: "1.jpg")
        testBox = testBase.testBoxs[3] //name: "Контейнер с игрушкам", image: #imageLiteral(resourceName: "box4.jpg")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //Запись кладовки
    func testSaveRoom(){
        XCTAssertNoThrow(try testBase.saveObject(objectForSave: testRoom!, base: .rooms))
        guard let room = try! testBase.fetchContext(base: .rooms, predicate: nil).first as? EntityRooms else {fatalError()}
        XCTAssertEqual(room.name, testRoom?.name)
    }
    
    //Запись коробки с привязкой к кладовке
    func testSaveBox(){
        testSaveRoom()
        guard let room = try! testBase.fetchContext(base: .rooms, predicate: nil).first else {fatalError()}
        XCTAssertNoThrow(testBase.saveObject(objectForSave: testBox!, base: .boxs, boxOrRoom: room))
        guard let box = try! testBase.fetchContext(base: .boxs, predicate: nil).first as? EntityBoxs else {fatalError()}
        XCTAssertTrue(box.name == testBox?.name)
        XCTAssertEqual(box.boxToRoom?.name, testRoom?.name)
    }
    
    //Запись вещи с привязкой к кладовке
    func testSaveThingInRoom(){
        testSaveRoom()
        testSaveBox()
        guard let room = try! testBase.fetchContext(base: .rooms, predicate: nil).first else {fatalError()}
        XCTAssertNoThrow(testBase.saveObject(objectForSave: testThingShoes!, base: .things, boxOrRoom: room))
        guard let shoes = try! testBase.fetchContext(base: .things, predicate: nil).first as? EntityThings else {fatalError()}
        XCTAssertEqual(shoes.thingToRoom?.name, testRoom?.name)
        XCTAssertNil(shoes.thingToBox)
    }
    
    //Запись вещи с привязкой к коробке которая лежит в кладовке
    func testSaveThingInBox(){
        testSaveRoom()
        testSaveBox()
        guard let box = try! testBase.fetchContext(base: .boxs, predicate: nil).first else {fatalError()}
        XCTAssertNoThrow(testBase.saveObject(objectForSave: testThingToy!, base: .things, boxOrRoom: box))
        guard let toy = try! testBase.fetchContext(base: .things, predicate: nil).first as? EntityThings else {fatalError()}
        XCTAssertTrue(toy.thingToBox?.name == testBox?.name)
        XCTAssertEqual(toy.thingToBox?.boxToRoom?.name, testRoom?.name)
        XCTAssertNil(toy.thingToRoom)
    }
    
    ///прверка поиска объектов по имени
    func testFindThingByName(){
        testSaveThingInBox() // записываем toy
        guard let room = try! testBase.fetchContext(base: .rooms, predicate: nil).first else {fatalError()} //записываем босоножки
        XCTAssertNoThrow(testBase.saveObject(objectForSave: testThingShoes!, base: .things, boxOrRoom: room))
        
        //поиск существующих объектов
        var objectShoes = testBase.findObjectByNameOrID(name: testThingShoes?.name, base: .things)
        XCTAssertFalse(objectShoes!.isEmpty)
        var objectToy = testBase.findObjectByNameOrID(name: testThingToy?.name, base: .things)
        XCTAssertFalse(objectToy!.isEmpty)
        var objectRoom = testBase.findObjectByNameOrID(name: testRoom?.name, base: .rooms)
        XCTAssertFalse(objectRoom!.isEmpty)
        var objectBox = testBase.findObjectByNameOrID(name: testBox?.name, base: .boxs)
        XCTAssertFalse(objectBox!.isEmpty)
        
        //поиск ложных объектов
        objectShoes = testBase.findObjectByNameOrID(name: "бооножки", base: .things)
        XCTAssertTrue(objectShoes!.isEmpty)
        objectToy = testBase.findObjectByNameOrID(name: "to1", base: .things)
        XCTAssertTrue(objectToy!.isEmpty)
        objectRoom = testBase.findObjectByNameOrID(name: "Клаовка1", base: .rooms)
        XCTAssertTrue(objectRoom!.isEmpty)
        objectBox = testBase.findObjectByNameOrID(name: "Контейнер с  игрушками", base: .boxs)
        XCTAssertTrue(objectBox!.isEmpty)
    }
    
    // извлекаем содержимое комнаты
    func testFetchContent(){
        testSaveThingInBox() // создаем room создаем box с привязкой к room и записываем toy в box
        guard let room = try! testBase.fetchContext(base: .rooms, predicate: nil).first else {fatalError()}
        XCTAssertNoThrow(testBase.saveObject(objectForSave: testThingShoes!, base: .things, boxOrRoom: room)) //записываем босоножки в room
        XCTAssertNoThrow(testBase.saveObject(objectForSave: testThingHelmet!, base: .things, boxOrRoom: room)) //записываем шлем в room
        
        let roomId = room.value(forKey: "id") as! UUID
        guard let objectRooms = testBase.findObjectByNameOrID(name: nil, id: roomId, base: .rooms)?[0] as? EntityRooms else {
                                                                                    XCTAssertTrue(false)
                                                                                    return}
        guard let contentRoom = objectRooms.roomToThing?.map({$0 as! EntityThings}) else {
                                                                                    XCTAssertTrue(false)
                                                                                    return}
        XCTAssertTrue (contentRoom.first?.value(forKey: "name") as? String == testThingShoes?.name)
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
