import XCTest
@testable import Bitcoin

class ScriptTests: XCTestCase {
    func testScript() {
        let privateKey = try! PrivateKey(wif: "92pMamV6jNyEq9pDpY4f6nBy9KpV2cfJT4L5zDUYiGqyQHJfF1K")
        let toAddress = "mv4rnyY3Su5gjcDNzbMLKBQkBicCtHUtFB" // https://testnet.coinfaucet.eu/en/
        let fromPublicKey = privateKey.publicKey()
        let fromPubKeyHash = Crypto.sha256ripemd160(fromPublicKey.data)
        let toPubKeyHash = Base58Check.decode(toAddress)!.dropFirst()

        let lockingScript1 = Script.buildPublicKeyHashOut(pubKeyHash: fromPubKeyHash)
        let lockingScript2 = Script.buildPublicKeyHashOut(pubKeyHash: toPubKeyHash)

        XCTAssertEqual(Script.getPublicKeyHash(from: lockingScript1), fromPubKeyHash)
        XCTAssertEqual(Script.getPublicKeyHash(from: lockingScript2), toPubKeyHash)
    }

    func testBinarySerialization() {
        XCTAssertEqual(Script().data, Data(), "Default script should be empty.")
        XCTAssertEqual(Script(data: Data())!.data, Data(), "Empty script should be empty.")
    }

    func testStandardScript() {
        let script = Script(data: Data(hex: "76a9147ab89f9fae3f8043dcee5f7b5467a0f0a6e2f7e188ac")!)!
        XCTAssertTrue(script.isPayToPublicKeyHashScript, "should be regular hash160 script")

        let address = try! Address(legacy: "1CBtcGivXmHQ8ZqdPgeMfcpQNJrqTrSAcG")
        let script2 = Script(address: address)
        XCTAssertEqual(script2!.data, script.data, "script created from extracted address should be the same as the original script")
        XCTAssertEqual(script2!.string, script.string, "script created from extracted address should be the same as the original script")
    }

    func testCreate2of3MultisigScript() {
        let aliceKey = try! PrivateKey(wif: "cNaP9iG9DaNNemnVa2LXvw4rby5Xc4k6qydENQmLBm2aD7gD7GJi")
        let bobKey = try! PrivateKey(wif: "cSZEkc5cpjjmfK8E9MbTmHwmzck8MokK5Wd9LMTv59qdNSQNGBbG")
        let charlieKey = try! PrivateKey(wif: "cUJiRP3A2KoCVi7fwYBGTKUaiHKgvT9CSiXpoGJdbYP9kEqHKU4q")

        let redeemScript = Script(publicKeys: [aliceKey.publicKey(), bobKey.publicKey(), charlieKey.publicKey()], signaturesRequired: 2)
        XCTAssertNotNil(redeemScript)
        let p2shScript = redeemScript!.toP2SH()
        XCTAssertEqual(p2shScript.hex, "a914629a500c5eaac9261cac990c72241a959ff2d3d987")
        let multisigAddr = redeemScript!.standardP2SHAddress(network: Network.testnet)
        XCTAssertEqual(multisigAddr.bech32, "tb1qv2d9qrz74tyjv89vnyx8yfq6jk0l957ef0cfkf", "multisig address should be the same as address created from bitcoin-ruby.")
    }
}
