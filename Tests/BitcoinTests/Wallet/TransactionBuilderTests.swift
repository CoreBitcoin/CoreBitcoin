import XCTest
@testable import Bitcoin

class TransactionBuilderTests: XCTestCase {
    func testBTCTransaction() {
        // Transaction in testnet3
        // https://api.blockcypher.com/v1/btc/test3/txs/0189910c263c4d416d5c5c2cf70744f9f6bcd5feaf0b149b02e5d88afbe78992

        // TransactionOutput
        let prevTxLockScript = Data(hex: "76a9142a539adfd7aefcc02e0196b4ccf76aea88a1f47088ac")
        let prevTxOutput = TransactionOutput(value: 169_012_961, lockingScript: prevTxLockScript!)

        // TransactionOutpoint
        let prevTxID = "1524ca4eeb9066b4765effd472bc9e869240c4ecb5c1ee0edb40f8b666088231"
        let prevTxHash = Data(Data(hex: prevTxID)!.reversed())
        let prevTxOutPoint = TransactionOutPoint(hash: prevTxHash, index: 1)

        // UnspentTransaction
        let unspentTransaction = UnspentTransaction(output: prevTxOutput,
                                      outpoint: prevTxOutPoint)
        let plan = TransactionPlan(unspentTransactions: [unspentTransaction], amount: 50_000_000, fee: 10_000_000, change: 109_012_961)
        let toAddress = try! Address(legacy: "mv4rnyY3Su5gjcDNzbMLKBQkBicCtHUtFB")
        let privKey = try! PrivateKey(wif: "92pMamV6jNyEq9pDpY4f6nBy9KpV2cfJT4L5zDUYiGqyQHJfF1K")
        let changeAddress = privKey.publicKey().toAddress()
        let tx: Transaction = TransactionBuilder.build(from: plan, toAddress: toAddress, changeAddress: changeAddress)

        let expectedSerializedTx: Data = Data(hex: "010000000131820866b6f840db0eeec1b5ecc44092869ebc72d4ff5e76b46690eb4eca24150100000000ffffffff0280f0fa02000000001976a9149f9a7abd600c0caa03983a77c8c3df8e062cb2fa88ace1677f06000000001976a9142a539adfd7aefcc02e0196b4ccf76aea88a1f47088ac00000000")!
        XCTAssertEqual(tx.serialized().hex, expectedSerializedTx.hex)
        // TODO: signature hash test
//        let expectedSignatureHash: Data = Data(hex: "fd2f20da1c28b008abcce8a8ac7e1a7687fc944e001a24fc3aacb6a7570a3d0f")!
//        XCTAssertEqual(tx.signatureHash(for: prevTxOutput, inputIndex: 0, hashType: SighashType.BTC.ALL), expectedSignatureHash)
    }
}
