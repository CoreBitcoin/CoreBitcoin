import XCTest
@testable import Bitcoin

class SerializationTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testUInt32toHex() {
        let d = Data([1, 2, 3, 4])
        let i: UInt32 = d.to(type: UInt32.self)
        XCTAssertEqual(i.hex, "04030201")
        XCTAssertEqual(i, 0x04030201)
    }

    func testUInt64toHex() {
        let d = Data([1, 2, 3, 4, 5, 6, 7, 8])
        let i: UInt64 = d.to(type: UInt64.self)
        XCTAssertEqual(i.hex, "0807060504030201")
        XCTAssertEqual(i, 0x0807060504030201)
    }

    func testDataToUInt256() {
        let d = Data([1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2])
        let i: UInt256 = d.to(type: UInt256.self)
        XCTAssertEqual(i.hex, "0200000000000000000000000000000000000000000000000000000000000001")
    }

    func testDataToInt32() {
        for _ in 0..<10 {
            for i in 0...255 {
                let data: Data = Data([UInt8(i)])
                let intValue: Int32 = data.to(type: Int32.self)
                XCTAssertEqual(intValue, Int32(i), "\(i) time")
            }
        }
    }
}
