//
//  StoreRoomTests.swift
//  StoreRoomTests
//
//  Created by Евгений Захаров on 03.08.2022.
//

import XCTest
@testable import StoreRoom

class StoreRoomTests: XCTestCase {
    let testBase = TestData()
    var testThingToy: Object?
    var testThingShoes: Object?
    var testRoom: Object?
    var testBox: Object?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testBase.clearBase()
        testThingToy = testBase.testThings[9] //name: "toy1", image: "toy1.jpg"
        testThingShoes = testBase.testThings[0] //name: "Босоножки", image: #imageLiteral(resourceName: "shoes2.jpg")
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
        XCTAssertEqual(room.name, "Кладовка1")
    }
    
    //Запись коробки с привязкой к кладовке
    func testSaveBox(){
        testSaveRoom()
        guard let room = try! testBase.fetchContext(base: .rooms, predicate: nil).first else {fatalError()}
        XCTAssertNoThrow(testBase.saveObject(objectForSave: testBox!, base: .boxs, boxOrRoom: room))
        guard let box = try! testBase.fetchContext(base: .boxs, predicate: nil).first as? EntityBoxs else {fatalError()}
        XCTAssertTrue(box.name == String("Контейнер с игрушками"))
        XCTAssertEqual(box.boxToRoom?.name, "Кладовка1")
    }
    
    //Запись вещи с привязкой к кладовке
    func testSaveThingInRoom(){
        testSaveRoom()
        testSaveBox()
        guard let room = try! testBase.fetchContext(base: .rooms, predicate: nil).first else {fatalError()}
        XCTAssertNoThrow(testBase.saveObject(objectForSave: testThingShoes!, base: .things, boxOrRoom: room))
        guard let shoes = try! testBase.fetchContext(base: .things, predicate: nil).first as? EntityThings else {fatalError()}
        XCTAssertEqual(shoes.thingToRoom?.name, "Кладовка1")
        XCTAssertNil(shoes.thingToBox)
    }
    
    //Запись вещи с привязкой к коробке которая лежит в кладовке
    func testSaveThingInBox(){
        testSaveRoom()
        testSaveBox()
        guard let box = try! testBase.fetchContext(base: .boxs, predicate: nil).first else {fatalError()}
        XCTAssertNoThrow(testBase.saveObject(objectForSave: testThingToy!, base: .things, boxOrRoom: box))
        guard let toy = try! testBase.fetchContext(base: .things, predicate: nil).first as? EntityThings else {fatalError()}
        XCTAssertTrue(toy.thingToBox?.name == String("Контейнер с игрушками"))
        XCTAssertEqual(toy.thingToBox?.boxToRoom?.name, "Кладовка1")
        XCTAssertNil(toy.thingToRoom)
    }
    
    ///прверка поиска объектов по имени
    func testFindThingByName(){
        testSaveThingInBox() // записываем toy
        guard let room = try! testBase.fetchContext(base: .rooms, predicate: nil).first else {fatalError()} //записываем босоножки
        XCTAssertNoThrow(testBase.saveObject(objectForSave: testThingShoes!, base: .things, boxOrRoom: room))
        
        //поиск существующих объектов
        var objectShoes = testBase.findObjectByName(name: "босоножки", base: .things)
        XCTAssertFalse(objectShoes!.isEmpty)
        var objectToy = testBase.findObjectByName(name: "toy1", base: .things)
        XCTAssertFalse(objectToy!.isEmpty)
        var objectRoom = testBase.findObjectByName(name: "Кладовка1", base: .rooms)
        XCTAssertFalse(objectRoom!.isEmpty)
        var objectBox = testBase.findObjectByName(name: "Контейнер с игрушками", base: .boxs)
        XCTAssertFalse(objectBox!.isEmpty)
        
        //поиск ложных объектов
        objectShoes = testBase.findObjectByName(name: "бооножки", base: .things)
        XCTAssertTrue(objectShoes!.isEmpty)
        objectToy = testBase.findObjectByName(name: "to1", base: .things)
        XCTAssertTrue(objectToy!.isEmpty)
        objectRoom = testBase.findObjectByName(name: "Клаовка1", base: .rooms)
        XCTAssertTrue(objectRoom!.isEmpty)
        objectBox = testBase.findObjectByName(name: "Контейнер с  игрушками", base: .boxs)
        XCTAssertTrue(objectBox!.isEmpty)
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
