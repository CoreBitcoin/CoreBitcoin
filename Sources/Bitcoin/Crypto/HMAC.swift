import Foundation
import CommonCrypto

public struct HMAC {
    public enum Algorithm {
        case sha1
        case sha256
        case sha512

        public var algorithm: CCHmacAlgorithm {
            switch self {
            case .sha1: return CCHmacAlgorithm(kCCHmacAlgSHA1)
            case .sha256: return CCHmacAlgorithm(kCCHmacAlgSHA256)
            case .sha512: return CCHmacAlgorithm(kCCHmacAlgSHA512)
            }
        }

        public var digestLength: Int {
            switch self {
            case .sha1: return Int(CC_SHA1_DIGEST_LENGTH)
            case .sha256: return Int(CC_SHA256_DIGEST_LENGTH)
            case .sha512: return Int(CC_SHA512_DIGEST_LENGTH)
            }
        }
    }

    public static func sign(data: Data, algorithm: Algorithm, key: Data) -> Data {
        let signature = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: algorithm.digestLength)
        defer { signature.deallocate() }

        data.withUnsafeBytes { dataBytes in
            key.withUnsafeBytes { keyBytes in
                CCHmac(algorithm.algorithm, keyBytes.baseAddress, key.count, dataBytes.baseAddress, data.count, signature)
            }
        }

        return Data(bytes: signature, count: algorithm.digestLength)
    }

    public static func sign(message: String, algorithm: Algorithm, key: String) -> String? {
        guard let messageData = message.data(using: .utf8),
            let keyData = key.data(using: .utf8)
        else { return nil }

        return sign(data: messageData, algorithm: algorithm, key: keyData).hex
    }
}
