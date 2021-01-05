//
//  TodoTests.swift
//  TodoTests
//
//  Created by 김태훈 on 2020/11/10.
//

import XCTest
import RealmSwift
@testable import DoIT

class TodoTests: XCTestCase {
    
    let itemManager = DIItemManager()
    
    override func setUp() {
        super.setUp()
        
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invo   cation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        insertItemTest()
        updateItemTest()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func insertItemTest() {
        
        let realm = try? Realm()
        var item: DIItem = DIItem()
        do {
            if let id = itemManager.incrementID() {
                item = DIItem(id: id, title: "titleText", descript: "descText", startDate: Date(), endDate: Date(), isSwitchOn: false)
                try realm?.write{
                    realm?.add(item)
                }
            }
            XCTAssertEqual(item.title, "titleText")
            XCTAssertEqual(item.descript, "descText")
            XCTAssertEqual(item.isSwitchOn, false)
        } catch {
            XCTAssert(false, "\(error)")
        }
    }
    
    func updateItemTest() {
        let realm = try? Realm()
        do {
            insertItemTest()
            
            let item = DIItem(id: 0, title: "title", descript: "desc", startDate: Date(), endDate: Date(), isSwitchOn: false)
            try realm?.write {
                realm?.add(item, update: .modified)
            }
            XCTAssertEqual(item.title, "title")
            XCTAssertEqual(item.descript, "desc")
        } catch {
            XCTAssert(false, "\(error)")
        }
    }
}
