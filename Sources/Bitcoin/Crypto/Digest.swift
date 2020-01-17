import CommonCrypto

public struct Digest {

    public static func sha1(bytes: UnsafeRawBufferPointer, length: UInt32) -> [UInt8] {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CC_SHA1(bytes.baseAddress, length, &hash)
        return hash
    }

    public static func sha256(bytes: UnsafeRawBufferPointer, length: UInt32) -> [UInt8] {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CC_SHA256(bytes.baseAddress, length, &hash)
        return hash
    }

    public static func sha512(bytes: UnsafeRawBufferPointer, length: UInt32) -> [UInt8] {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        CC_SHA512(bytes.baseAddress, length, &hash)
        return hash
    }
}
