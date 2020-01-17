import XCTest
@testable import Bitcoin

/*
class TransactionSignerTests: XCTestCase {
    func testSign() {
        // Transaction on Bitcoin Testnet
        // TxID : c2bf9f43371260fe5c07155179a4f197de4bbcaee67f283b13cc6376220521dc
        // https://www.blockchain.com/btctest/tx/c2bf9f43371260fe5c07155179a4f197de4bbcaee67f283b13cc6376220521dc

        // TransactionOutput
        let prevTxLockScript = Data(hex: "00147659c319aeb62ba86b54253f0619d92b884c76ba")
        let prevTxOutput = TransactionOutput(value: 3812419, lockingScript: prevTxLockScript!)

        // TransactionOutpoint
        let prevTxID = "f017febe127ad60efa9f98ba94fbae8f691b94e09a30b3a259ddd32510b25524"
        let prevTxHash = Data(Data(hex: prevTxID)!.reversed())
        let prevTxOutPoint = TransactionOutPoint(hash: prevTxHash, index: 0)

        // UnspentTransaction
        let unspentTransaction = UnspentTransaction(output: prevTxOutput, outpoint: prevTxOutPoint)
        let plan = TransactionPlan(unspentTransactions: [unspentTransaction], amount: 1000000, fee: 142, change: 2812277)
        let toAddress = try! Address(legacy: "2MtCVwByXtopsNVRDCw8on3CenB3DvyfU8f")
        let changeAddress = try! Address("tb1q8kpc6ajyu06u6ry09s3dqj3a70zsaw7vlap3mt")
        let tx = TransactionBuilder.build(from: plan, toAddress: toAddress, changeAddress: changeAddress)

        let privKey = try! PrivateKey(wif: "cPST7q5hWYpGWfZzwgudVVfSt482on9QHZ4EsQ2eMC8NmUnXZ1pN")
        //let privKey = try! PrivateKey(wif: "L1WFAgk5LxC5NLfuTeADvJ5nm3ooV3cKei5Yi9LJ8ENDfGMBZjdW")
        let signer = TransactionSigner(unspentTransactions: plan.unspentTransactions, transaction: tx, sighashHelper: BTCSignatureHashHelper(hashType: .ALL))
        let signedTx = try! signer.sign(with: [privKey])
        let expected: Data = Data(hex: "0100000001e28c2b955293159898e34c6840d99bf4d390e2ee1c6f606939f18ee1e2000d05020000006b483045022100b70d158b43cbcded60e6977e93f9a84966bc0cec6f2dfd1463d1223a90563f0d02207548d081069de570a494d0967ba388ff02641d91cadb060587ead95a98d4e3534121038eab72ec78e639d02758e7860cdec018b49498c307791f785aa3019622f4ea5bffffffff0258020000000000001976a914769bdff96a02f9135a1d19b749db6a78fe07dc9088ace5100000000000001976a9149e089b6889e032d46e3b915a3392edfd616fb1c488ac00000000")!
        // TODO: FIXME, need to implement witness to make test pass or use a transaction withous bech32
        // XCTAssertEqual(signedTx.serialized(), expected)
        // XCTAssertEqual(signedTx.txID, "c2bf9f43371260fe5c07155179a4f197de4bbcaee67f283b13cc6376220521dc")
    }
}
*/
