import XCTest
@testable import Bitcoin

class CryptoTests: XCTestCase {
    func testSHA256() {
        XCTAssertEqual(Crypto.sha256("hello".data(using: .ascii)!).hex, "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824")
        XCTAssertEqual(Crypto.sha256sha256("hello".data(using: .ascii)!).hex, "9595c9df90075148eb06860365df33584b75bff782a510c6cd4883a419833d50")
    }

    func testSHA256RIPEMD160() {
        XCTAssertEqual(Crypto.sha256ripemd160("hello".data(using: .ascii)!).hex, "b6a9c8c230722b7c748331a8b450f05566dc7d0f")
    }

    func testSign() {
        let msg = Data(hex: "52204d20fd0131ae1afd173fd80a3a746d2dcc0cddced8c9dc3d61cc7ab6e966")!
        let pk = Data(hex: "16f243e962c59e71e54189e67e66cf2440a1334514c09c00ddcc21632bac9808")!
        let privateKey = PrivateKey(data: pk)

        let signature = try? Crypto.sign(msg, privateKey: privateKey)

        XCTAssertNotNil(signature)
        XCTAssertEqual(signature?.hex, "3044022055f4b20035cbb2e85b7a04a0874c80d5822758f4e47a9a69db04b29f8b218f920220491e6a13296cfe2186da3a3ca565a179def3808b12d184553a8e3acfe1467273")
    }

    func testHMAC() {
        let testStr = "param1=val1&param2=val2"
        let secretKey = "password"
        let result = Crypto.hmac(data: testStr.data(using: .utf8)!, key: secretKey.data(using: .utf8)!, algorithm: .sha512)
        XCTAssertEqual(result.hex, "051464ad12cd03cf6c0f968317dfcededafeb8a267d6da7869e0588aa887bde6f4f0fe2077aed2a32a748c9e2d59ddc2bb7c3f034a4aa9fc9b0752c750daae94")
    }
}
