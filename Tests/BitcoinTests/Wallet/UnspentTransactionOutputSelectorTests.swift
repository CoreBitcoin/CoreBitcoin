import XCTest
@testable import Bitcoin

func buildUnspent(_ value: UInt64) -> UnspentTransaction {
    let outpoint: TransactionOutPoint = TransactionOutPoint(hash: Data(), index: 0)
    let output: TransactionOutput = TransactionOutput(value: value, lockingScript: Data())
    return UnspentTransaction(output: output, outpoint: outpoint)
}

class UnspentTransactionOutputSelectorTests: XCTestCase {
    var unspentTransactions: [UnspentTransaction] = []

    override func setUp() {
        unspentTransactions = []
    }

    func testEmptyUnspentTransactions() {
        // If unspentTransactions are empty, returns empty
        let selected: [UnspentTransaction] = UnspentTransactionSelector
            .select(from: unspentTransactions, targetValue: 3000, feePerByte: 1)
        XCTAssertTrue(selected.isEmpty)
    }

    func testTargetValueIsZero() {
        // If targetValue is 0, returns empty
        unspentTransactions.append(buildUnspent(1000))
        unspentTransactions.append(buildUnspent(2000))
        unspentTransactions.append(buildUnspent(3000))
        let selected: [UnspentTransaction] = UnspentTransactionSelector
            .select(from: unspentTransactions, targetValue: 0, feePerByte: 1)
        XCTAssertTrue(selected.isEmpty)
    }

    func testSingleUnspentTransactionCloseToDouble() {
        // 1. Single unspentTransaction closest 2x
        unspentTransactions.append(buildUnspent(2000))
        unspentTransactions.append(buildUnspent(6000))
        unspentTransactions.append(buildUnspent(1000))
        unspentTransactions.append(buildUnspent(11000))
        unspentTransactions.append(buildUnspent(12000))

        let selected: [UnspentTransaction] = UnspentTransactionSelector
            .select(from: unspentTransactions, targetValue: 5000, feePerByte: 1)
        XCTAssertEqual(selected.count, 1)
        XCTAssertEqual(selected.sum(), 11000)
    }

    func testTwoUnspentTransactionsCloseToDouble() {
        // 3. Two unspentTransactions closest to 2x value of target
        unspentTransactions.append(buildUnspent(4000))
        unspentTransactions.append(buildUnspent(2000))
        unspentTransactions.append(buildUnspent(5000))

        let selected: [UnspentTransaction] = UnspentTransactionSelector
            .select(from: unspentTransactions, targetValue: 4999, feePerByte: 1)
        XCTAssertEqual(selected.count, 2)
        XCTAssertEqual(selected.sum(), 9000)
    }

    func testFewestUnspentTransactionsGreaterThanTarget() {
        // 5. Fewest unspentTransactions greater than 1x value of target
        unspentTransactions.append(buildUnspent(1000))
        unspentTransactions.append(buildUnspent(2000))
        unspentTransactions.append(buildUnspent(3000))
        unspentTransactions.append(buildUnspent(4000))
        unspentTransactions.append(buildUnspent(5000))
        unspentTransactions.append(buildUnspent(6000))
        unspentTransactions.append(buildUnspent(7000))
        unspentTransactions.append(buildUnspent(8000))
        unspentTransactions.append(buildUnspent(9000))

        let selected: [UnspentTransaction] = UnspentTransactionSelector
            .select(from: unspentTransactions, targetValue: 28000, feePerByte: 1)
        XCTAssertEqual(selected.count, 4)
        XCTAssertEqual(selected.sum(), 30000)
        XCTAssertEqual(selected[0].output.value, 6000)
        XCTAssertEqual(selected[1].output.value, 7000)
        XCTAssertEqual(selected[2].output.value, 8000)
        XCTAssertEqual(selected[3].output.value, 9000)
    }

    func testInsufficientFund() {
        // 6. Insufficient funds
        unspentTransactions.append(buildUnspent(4000))
        unspentTransactions.append(buildUnspent(4000))
        unspentTransactions.append(buildUnspent(4000))

        let selected: [UnspentTransaction] = UnspentTransactionSelector
            .select(from: unspentTransactions, targetValue: 15000, feePerByte: 1)
        XCTAssertEqual(selected.count, 3)
        XCTAssertEqual(selected.sum(), 12000)
    }

    func testUnspentTransactions1() {
        // Trust/wallet-core: SelectUnpsents1
        unspentTransactions.append(buildUnspent(4000))
        unspentTransactions.append(buildUnspent(2000))
        unspentTransactions.append(buildUnspent(6000))
        unspentTransactions.append(buildUnspent(1000))
        unspentTransactions.append(buildUnspent(11_000))
        unspentTransactions.append(buildUnspent(12_000))
        let selected: [UnspentTransaction] = UnspentTransactionSelector
            .select(from: unspentTransactions, targetValue: 5000, feePerByte: 1)
        XCTAssertEqual(selected.count, 1)
        XCTAssertEqual(selected.sum(), 11_000)
    }

    func testUnspentTransactions2() {
        // Trust/wallet-core: SelectUnpsents2
        unspentTransactions.append(buildUnspent(4000))
        unspentTransactions.append(buildUnspent(2000))
        unspentTransactions.append(buildUnspent(6000))
        unspentTransactions.append(buildUnspent(1000))
        unspentTransactions.append(buildUnspent(50_000))
        unspentTransactions.append(buildUnspent(120_000))
        let selected: [UnspentTransaction] = UnspentTransactionSelector
            .select(from: unspentTransactions, targetValue: 10_000, feePerByte: 1)
        XCTAssertEqual(selected.count, 1)
        XCTAssertEqual(selected.sum(), 50_000)
    }

    func testUnspentTransactions3() {
        // Trust/wallet-core: SelectUnpsents3
        unspentTransactions.append(buildUnspent(4000))
        unspentTransactions.append(buildUnspent(2000))
        unspentTransactions.append(buildUnspent(5000))
        let selected: [UnspentTransaction] = UnspentTransactionSelector
            .select(from: unspentTransactions, targetValue: 6000, feePerByte: 1)
        XCTAssertEqual(selected.count, 2)
        XCTAssertEqual(selected.sum(), 9000)
    }

    func testUnspentTransactions4() {
        // Trust/wallet-core: SelectUnpsents4
        unspentTransactions.append(buildUnspent(40_000))
        unspentTransactions.append(buildUnspent(30_000))
        unspentTransactions.append(buildUnspent(30_000))
        let selected: [UnspentTransaction] = UnspentTransactionSelector
            .select(from: unspentTransactions, targetValue: 50_000, feePerByte: 1)
        XCTAssertEqual(selected.count, 2)
        XCTAssertEqual(selected.sum(), 70_000)
    }

    func testUnspentTransactions5() {
        // Trust/wallet-core: SelectUnpsents5
        unspentTransactions.append(buildUnspent(1000))
        unspentTransactions.append(buildUnspent(2000))
        unspentTransactions.append(buildUnspent(3000))
        unspentTransactions.append(buildUnspent(4000))
        unspentTransactions.append(buildUnspent(5000))
        unspentTransactions.append(buildUnspent(6000))
        unspentTransactions.append(buildUnspent(7000))
        unspentTransactions.append(buildUnspent(8000))
        unspentTransactions.append(buildUnspent(9000))
        let selected: [UnspentTransaction] = UnspentTransactionSelector
            .select(from: unspentTransactions, targetValue: 28_000, feePerByte: 1)
        XCTAssertEqual(selected.count, 4)
        XCTAssertEqual(selected.sum(), 30_000)
    }

    func testSelectUnpsentsInsufficient()  {
        // Trust/wallet-core: SelectUnpsentsInsufficient
        unspentTransactions.append(buildUnspent(4000))
        unspentTransactions.append(buildUnspent(4000))
        unspentTransactions.append(buildUnspent(4000))
        let selected: [UnspentTransaction] = UnspentTransactionSelector
            .select(from: unspentTransactions, targetValue: 15_000, feePerByte: 1)
        XCTAssertEqual(selected.count, 3)
        XCTAssertEqual(selected.sum(), 12_000)
    }

    func testSelectCustom()  {
        // Trust/wallet-core: SelectCustomCase
        unspentTransactions.append(buildUnspent(794_121))
        unspentTransactions.append(buildUnspent(2_289_357))
        let selected: [UnspentTransaction] = UnspentTransactionSelector
            .select(from: unspentTransactions, targetValue: 2_287_189, feePerByte: 61)
        XCTAssertEqual(selected.count, 2)
        XCTAssertEqual(selected.sum(), 3_083_478)

    }

    func testSelectMax()  {
        // Trust/wallet-core: SelectMaxCase
        unspentTransactions.append(buildUnspent(10_189_534))
        let selected: [UnspentTransaction] = UnspentTransactionSelector
            .select(from: unspentTransactions, targetValue: 10_189_534, feePerByte: 1)
        XCTAssertEqual(selected.count, 1)
        XCTAssertEqual(selected.sum(), 10_189_534)
    }
}
