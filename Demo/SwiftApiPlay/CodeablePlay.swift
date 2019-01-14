//
//  CodeablePlay.swift
//  SwiftApiPlay
//
//  Created by huahuahu on 2019/1/13.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import XCTest

class CodablePlay: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}

//public protocol Encodable {
//    /// 将值编码到给定的 encoder 中。
//    public func encode(to encoder: Encoder) throws
//}
///// 某个类型可以从外部表示中解码得到自身。
//public protocol Decodable {
//    /// 通过从给定的 decoder 中解码来创建新的实例。
//    public init(from decoder: Decoder) throws
//}
//因为大多数实现了其中一个协议的类型，也会实现另一个，所以标准库中还提供了 Codable 类型别名，来作为这两个协议组合后的简写：
//
//public typealias Codable = Decodable & Encodable”
//

//默认实现了codeable
struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double
}

//也默认实现了
struct Placemark: Codable {
    var name: String
    var coordinate: Coordinate
}

extension CodablePlay {
    func testJsonSimpleCodable() {
        let places = [Placemark.init(name: "Berlin", coordinate: .init(latitude: 52, longitude: 13)),
                      Placemark.init(name: "Cape Town", coordinate: .init(latitude: -34, longitude: 18))]
        do {
            let encoder = JSONEncoder.init() //初始化编码器
            let jsonData = try encoder.encode(places)// 转为 Data
            let jsonStr = String.init(data: jsonData, encoding: .utf8) // 转为字符串
            XCTAssertNotNil(jsonStr)
            print(jsonStr!)

            // decode
            let decoder = JSONDecoder.init()
            let decoded = try decoder.decode([Placemark].self, from: jsonData)
            XCTAssertEqual(decoded.count, 2)
        } catch {
            print("\(error.localizedDescription)")
        }
    }
}

struct Placemark2: Codable {
    var name: String
    var coordinate: Coordinate
    private enum CodingKeys: String, CodingKey {
        case name = "label"
        case coordinate
    }
    // 编译器生成的编码和解码方法将使用重载后的 CodingKeys，即label
}

extension CodablePlay {
    func testJsonCustomCodable() {
        let places = [Placemark2.init(name: "Berlin", coordinate: .init(latitude: 52, longitude: 13)),
                      Placemark2.init(name: "Cape Town", coordinate: .init(latitude: -34, longitude: 18))]
        do {
            let encoder = JSONEncoder.init() //初始化编码器
            let jsonData = try encoder.encode(places)// 转为 Data
            let jsonStr = String.init(data: jsonData, encoding: .utf8) // 转为字符串
            XCTAssertNotNil(jsonStr)
            XCTAssertTrue(jsonStr!.contains("label"))
            print(jsonStr!)

            // decode
            let decoder = JSONDecoder.init()
            let decoded = try decoder.decode([Placemark2].self, from: jsonData)
            XCTAssertEqual(decoded.count, 2)
        } catch {
            print("\(error.localizedDescription)")
        }
    }
}

// 跳过编码
struct Placemark3: Codable {
    //需要有默认实现
    var name: String = "(Unknown)"
    var coordinate: Coordinate
    //没有name，不被编码
    private enum CodingKeys: CodingKey {
        case coordinate
    }
}

extension CodablePlay {
    func testJsonCustomCodableJumpOver() {
        let places = [Placemark3.init(name: "Berlin", coordinate: .init(latitude: 52, longitude: 13)),
                      Placemark3.init(name: "Cape Town", coordinate: .init(latitude: -34, longitude: 18))]
        do {
            let encoder = JSONEncoder.init() //初始化编码器
            let jsonData = try encoder.encode(places)// 转为 Data
            let jsonStr = String.init(data: jsonData, encoding: .utf8) // 转为字符串
            XCTAssertNotNil(jsonStr)
            XCTAssertFalse(jsonStr!.contains("name"))
            print(jsonStr!)

            // decode
            let decoder = JSONDecoder.init()
            let decoded = try decoder.decode([Placemark3].self, from: jsonData)
            XCTAssertEqual(decoded.count, 2)
        } catch {
            print("\(error.localizedDescription)")
        }
    }
}

//自定义编解码
struct Placemark4: Codable {
    var name: String
    var coordinate: Coordinate?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        do {
            self.coordinate = try container.decodeIfPresent(Coordinate.self,
                                                            forKey: .coordinate)
        } catch DecodingError.keyNotFound {
            self.coordinate = nil
        }
    }
}

extension CodablePlay {
    func testJsonCustomCodableTotalCustom() {
        let invalidJSONInput = """
        [
            {
                "name" : "Berlin",
                "coordinate": {}
            }
        ]
        """

        do {
            let inputData = invalidJSONInput.data(using: .utf8)!
            let decoder = JSONDecoder()
            let decoded = try decoder.decode([Placemark4].self, from: inputData)
            print(decoded)
        } catch {
            XCTFail("error")
            print(error.localizedDescription)
        }
    }
}
