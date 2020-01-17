import XCTest
@testable import Bitcoin

class AddressTests: XCTestCase {

    func testMainnet() {
        let privateKey = try! PrivateKey(wif: "5K6EwEiKWKNnWGYwbNtrXjA8KKNntvxNKvepNqNeeLpfW7FSG1v")
        let publicKey = privateKey.publicKey()
        let address1 = publicKey.toAddress()
        XCTAssertEqual(address1.legacy, "1AC4gh14wwZPULVPCdxUkgqbtPvC92PQPN")
        XCTAssertEqual(address1.bech32, "bc1qvngvs7aqnq2h0a890qkcvwjewmllljrd9tguf8")

        let address2 = try? Address(legacy: "1AC4gh14wwZPULVPCdxUkgqbtPvC92PQPN")
        XCTAssertNotNil(address2)
        XCTAssertEqual(address2?.network, Network.mainnet)
        XCTAssertEqual(address2?.hashType, Bitcoin.Address.HashType.pubKeyHash)
        XCTAssertEqual(address2?.hashSize, Bitcoin.Address.HashSize.bits160)
        XCTAssertEqual(address2!.bech32, "bc1qvngvs7aqnq2h0a890qkcvwjewmllljrd9tguf8")

        let address3 = try? Address("bc1qvngvs7aqnq2h0a890qkcvwjewmllljrd9tguf8")
        XCTAssertNotNil(address3)
        XCTAssertEqual(address3?.network, Network.mainnet)
        XCTAssertEqual(address3?.hashType, Bitcoin.Address.HashType.pubKeyHash)
        XCTAssertEqual(address3?.hashSize, Bitcoin.Address.HashSize.bits160)
        XCTAssertEqual(address3!.legacy, "1AC4gh14wwZPULVPCdxUkgqbtPvC92PQPN")
    }

    func testTestnet() {
        let privateKey = try! PrivateKey(wif: "92pMamV6jNyEq9pDpY4f6nBy9KpV2cfJT4L5zDUYiGqyQHJfF1K")
        let publicKey = privateKey.publicKey()
        let address1 = publicKey.toAddress()
        XCTAssertEqual(address1.legacy, "mjNkq5ycsAfY9Vybo9jG8wbkC5mbpo4xgC")
        XCTAssertEqual(address1.bech32, "tb1q9ffe4h7h4m7vqtspj66veam2a2y2rarsq2lmz4")

        let address2 = try? Address(legacy: "mjNkq5ycsAfY9Vybo9jG8wbkC5mbpo4xgC")
        XCTAssertNotNil(address2)
        XCTAssertEqual(address2?.network, Network.testnet)
        XCTAssertEqual(address2?.hashType, Bitcoin.Address.HashType.pubKeyHash)
        XCTAssertEqual(address2?.hashSize, Bitcoin.Address.HashSize.bits160)
        XCTAssertEqual(address2!.bech32, "tb1q9ffe4h7h4m7vqtspj66veam2a2y2rarsq2lmz4")

        let address3 = try? Address("tb1q9ffe4h7h4m7vqtspj66veam2a2y2rarsq2lmz4")
        XCTAssertNotNil(address3)
        XCTAssertEqual(address3?.network, Network.testnet)
        XCTAssertEqual(address3?.hashType, Bitcoin.Address.HashType.pubKeyHash)
        XCTAssertEqual(address3?.hashSize, Bitcoin.Address.HashSize.bits160)
        XCTAssertEqual(address3!.legacy, "mjNkq5ycsAfY9Vybo9jG8wbkC5mbpo4xgC")
    }

    func testInvalidChecksumLegacyAddress() {
        do {
            _ = try Address(legacy: "175tWpb8K1S7NmH4Zx6rewF9WQrcZv245W")
            XCTFail("Should throw invalid checksum error.")
        } catch AddressError.invalid {
            // Success
        } catch {
            XCTFail("Should throw invalid checksum error.")
        }
    }
}
