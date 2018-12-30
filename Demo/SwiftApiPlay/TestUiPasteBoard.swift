//
//  TestUiPasteBoard.swift
//  SwiftApiPlay
//
//  Created by huahuahu on 2018/12/30.
//  Copyright © 2018 huahuahu. All rights reserved.
//
// UIPasteBoard 的Api
import XCTest
import UIKit
import MobileCoreServices

//swiftlint:disable force_cast
//swiftlint:disable force_try

class TestUiPasteBoard: XCTestCase {
    static let customName = UIPasteboard.Name.init("test")
    let customPastBoard = UIPasteboard.init(name: TestUiPasteBoard.customName, create: true)!
    let currentNotExistPasteBoardName = UIPasteboard.Name.init("目前还不存在的剪切板名字")

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // 清除所有的东西
        UIPasteboard.general.setItems([], options: [:])

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        UIPasteboard.remove(withName: TestUiPasteBoard.customName)
        UIPasteboard.remove(withName: currentNotExistPasteBoardName)
    }

    func testChangeCount() {
        let currentCount = UIPasteboard.general.changeCount
        UIPasteboard.general.string = "😄"
        XCTAssert(UIPasteboard.general.changeCount == currentCount + 1, "increase")

        let countBefore = customPastBoard.changeCount
        customPastBoard.string = "😢"
        let countAfter = customPastBoard.changeCount
        XCTAssert(countAfter == countBefore + 1)
    }

    func testCreateUIPasteBoard() {
        var board = UIPasteboard.init(name: TestUiPasteBoard.customName, create: false)
        XCTAssertNotNil(board, "已经创建的粘贴板，可以拿到")
        board = UIPasteboard.init(name: currentNotExistPasteBoardName, create: false)
        XCTAssertNil(board, "还没创建，取不到")
        board = UIPasteboard.init(name: currentNotExistPasteBoardName, create: true)
        XCTAssertNotNil(board, "还没创建，新创建一个")
    }

    func testItemsInPasteBoard() {
        var itemsCount = customPastBoard.numberOfItems
        XCTAssert(itemsCount == 0, "最开始是0")

        customPastBoard.addItems([["itemName": "item"]])
        itemsCount = customPastBoard.numberOfItems
        XCTAssertEqual(itemsCount, 1, "增加了一个")

        customPastBoard.addItems([["itemName1": "item1"]])
        itemsCount = customPastBoard.numberOfItems
        XCTAssertEqual(itemsCount, 2, "又增加了一个")

        customPastBoard.addItems([["itemName2": "item2"]])
        itemsCount = customPastBoard.numberOfItems
        XCTAssertEqual(itemsCount, 3, "又增加了一个")

        customPastBoard.setItems([["newitemName": "newItemValue"]], options: [:])
        itemsCount = customPastBoard.numberOfItems
        XCTAssertEqual(itemsCount, 1, "重新设置了剪切板")
    }

    func testSetString() {
        XCTAssertEqual(customPastBoard.numberOfItems, 0, "最开始什么都没有")
        customPastBoard.strings = ["first", "second"]
        XCTAssertEqual(customPastBoard.numberOfItems, 2, "新增了两个item")
        XCTAssertTrue(customPastBoard.hasStrings)
        if customPastBoard.hasStrings {
            XCTAssertEqual(customPastBoard.strings, ["first", "second"], "存取要一致")
        }

        //设置string
        customPastBoard.string = "newString"
        XCTAssertEqual(customPastBoard.numberOfItems, 1, "设置了string前，会清除当前所有的数据")
        XCTAssertTrue(customPastBoard.hasStrings)
    }

    func testSetValue() {
        XCTAssertEqual(customPastBoard.numberOfItems, 0, "最开始什么都没有")
        customPastBoard.setItems([["item1": 1], ["item2": 2]], options: [:])
        XCTAssertEqual(customPastBoard.numberOfItems, 2, "设置item有两项")

        //设置customType 的value
        customPastBoard.setValue("stringvalue" as NSString, forPasteboardType: "customType")
        XCTAssertEqual(customPastBoard.numberOfItems, 1, "设置value，会先清空当前剪切板")

        //可以取出来，但是type是自定义的，因此取出来是Data类型
        guard let value = customPastBoard.value(forPasteboardType: "customType") as? Data else {
            XCTFail("取出来的不是Data")
            return
        }
        let string = String.init(data: value, encoding: .utf8)
        XCTAssertEqual(string, "stringvalue", "存取应该一致")

        //设置标准type的value
        customPastBoard.setValue("stringvalue", forPasteboardType: kUTTypeUTF8PlainText as String)
        XCTAssertEqual(customPastBoard.numberOfItems, 1, "设置value，会先清空当前剪切板")
        let stringRetrive = customPastBoard.value(forPasteboardType: kUTTypeUTF8PlainText as String) as! String
        XCTAssertEqual(stringRetrive, "stringvalue", "标准的type，可以直接取出来")

//        let customObj = TestClass.init()
        //        for all other data, such as raw binary data, use the setData(_:forPasteboardType:) method.)
//        // 会报错: value is not a valid property list type
////       customPastBoard.setValue(customObj, forPasteboardType: "customObject")
    }

    func testSetData() {
        XCTAssertEqual(customPastBoard.numberOfItems, 0, "最开始什么都没有")
        let codeableObj = ClassNSCoding.init()
        codeableObj.intValue = 2
        let encodedData = try! NSKeyedArchiver.archivedData(withRootObject: codeableObj, requiringSecureCoding: true)
        customPastBoard.setData(encodedData, forPasteboardType: "customType")
        XCTAssertEqual(customPastBoard.numberOfItems, 1, "设置value，会先清空当前剪切板")
        guard let data = customPastBoard.data(forPasteboardType: "customType") else {
            XCTFail("取出来不是Data")
            return
        }

        let unarchivedObj = try! NSKeyedUnarchiver.unarchivedObject(ofClass: ClassNSCoding.self, from: data)
        XCTAssertEqual(unarchivedObj!.intValue, codeableObj.intValue, "存取应该一致")
    }

    func testTypes() {
        XCTAssertEqual(customPastBoard.numberOfItems, 0, "最开始什么都没有")
        XCTAssertTrue(customPastBoard.types.isEmpty)
        customPastBoard.setValue("value", forPasteboardType: "type")
        XCTAssertEqual(customPastBoard.types.count, 1, "第一个item只有一个")
        XCTAssertEqual(customPastBoard.types.first!, "type", "就是type")
        customPastBoard.addItems([["newtype": "newValue"]])
        XCTAssertEqual(customPastBoard.types.count, 1, "第一个item只有一个，不关第二个item的事情")

        let firstItemContent = ["type1": "value1", "type2": "value2"]
        customPastBoard.setItems([firstItemContent], options: [:])
        XCTAssertEqual(customPastBoard.types.count, 2, "此时第一个item有两个")
        XCTAssertTrue(customPastBoard.contains(pasteboardTypes: ["type1"]))
        XCTAssertTrue(customPastBoard.contains(pasteboardTypes: ["type2"]))
        XCTAssertTrue(customPastBoard.contains(pasteboardTypes: ["type1", "type2"]))
        XCTAssertFalse(customPastBoard.contains(pasteboardTypes: ["unexisttype"]))
    }

}

private class TestClass {

}

class ClassNSCoding: NSObject, NSSecureCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(intValue, forKey: "int")
    }

    required init?(coder aDecoder: NSCoder) {
        intValue = aDecoder.decodeInteger(forKey: "int")
        super.init()
    }

    var intValue = 1

    override init() {

    }

    static var supportsSecureCoding: Bool = true
}
