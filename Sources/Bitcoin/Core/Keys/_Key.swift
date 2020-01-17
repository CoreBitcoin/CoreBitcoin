import Foundation

class _Key {
    static func deriveKey(password: String, salt: Data, iterations:Int, keyLength: Int) -> Data {
        return PKCS5.pbkdf2SHA512(password: password,
                                  salt: salt,
                                  keyByteCount: keyLength,
                                  rounds: iterations)!
    }
}
