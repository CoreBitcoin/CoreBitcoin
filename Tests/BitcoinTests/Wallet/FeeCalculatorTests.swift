import XCTest
@testable import Bitcoin

final class FeeCalculatorTests: XCTestCase {
    func testCalculateDust() {
        XCTAssertEqual(FeeCalculator.calculateDust(feePerByte: 1), 546)
        XCTAssertEqual(FeeCalculator.calculateDust(feePerByte: 2), 1092)
        XCTAssertEqual(FeeCalculator.calculateDust(feePerByte: 123), 67158)
    }

    func testCalculateSingleInputFee() {
        XCTAssertEqual(FeeCalculator.calculateSingleInputFee(feePerByte: 1), 148)
        XCTAssertEqual(FeeCalculator.calculateSingleInputFee(feePerByte: 2), 296)
        XCTAssertEqual(FeeCalculator.calculateSingleInputFee(feePerByte: 123), 18_204)
    }

    func testCalculateFee() {
        XCTAssertEqual(FeeCalculator.calculateFee(inputs: 0, outputs: 0, feePerByte: 1), 0)
        XCTAssertEqual(FeeCalculator.calculateFee(inputs: 1, outputs: 0, feePerByte: 1), 158)
        XCTAssertEqual(FeeCalculator.calculateFee(inputs: 0, outputs: 1, feePerByte: 1), 0)
        XCTAssertEqual(FeeCalculator.calculateFee(inputs: 1, outputs: 1, feePerByte: 1), 192)
        XCTAssertEqual(FeeCalculator.calculateFee(inputs: 1, outputs: 1, feePerByte: 1), 192)
        XCTAssertEqual(FeeCalculator.calculateFee(inputs: 1, outputs: 2, feePerByte: 1), 226)
        XCTAssertEqual(FeeCalculator.calculateFee(inputs: 2, outputs: 1, feePerByte: 1), 340)
        XCTAssertEqual(FeeCalculator.calculateFee(inputs: 2, outputs: 2, feePerByte: 1), 374)
        XCTAssertEqual(FeeCalculator.calculateFee(inputs: 3, outputs: 1, feePerByte: 1), 488)
        XCTAssertEqual(FeeCalculator.calculateFee(inputs: 3, outputs: 2, feePerByte: 1), 522)
        XCTAssertEqual(FeeCalculator.calculateFee(inputs: 10, outputs: 20, feePerByte: 1), 2170)
        XCTAssertEqual(FeeCalculator.calculateFee(inputs: 10, outputs: 2, feePerByte: 1), 1558)
        XCTAssertEqual(FeeCalculator.calculateFee(inputs: 10, outputs: 2, feePerByte: 123), 191_634)
    }
}
