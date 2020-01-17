import XCTest
@testable import Bitcoin

class Base58Tests: XCTestCase {
    func testEncode() {
        XCTAssertEqual(Base58.encode(Data(hex: "7361746f7368696e616b616d6f746f")!), "4EDyQfUyxfCbahHLLssst")
        XCTAssertEqual(Base58.encode(Data(hex: "304f496c")!), "2Ed3AB")
    }

    func testDecode() {
        XCTAssertEqual(Base58.decode("4EDyQfUyxfCbahHLLssst"), Data(hex: "7361746f7368696e616b616d6f746f")!)
        XCTAssertNil(Base58.decode(""))
        XCTAssertNil(Base58.decode(" "))
        XCTAssertNil(Base58.decode("0OIl"))
    }
}
