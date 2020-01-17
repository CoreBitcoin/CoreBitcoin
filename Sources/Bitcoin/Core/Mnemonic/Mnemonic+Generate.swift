import Foundation

// MARK: Generate
public extension Mnemonic {
    static func generate(strength: Strength = .default, language: Language = .english) throws -> [String] {
        let entropy = try securelyGenerateBytes(count: strength.byteCount)
        return try generate(entropy: entropy, language: language)
    }
}

internal extension Mnemonic {
    static func generate(
        entropy: Data,
        language: Language = .english
    ) throws -> [String] {

        guard let strength = Mnemonic.Strength(byteCount: entropy.count) else {
            throw Error.unsupportedByteCountOfEntropy(got: entropy.count)
        }

        let words = wordList(for: language)
        let hash = Crypto.sha256(entropy)

        let checkSumBits = BitArray(data: hash).prefix(strength.checksumLengthInBits)

        let bits = BitArray(data: entropy) + checkSumBits

		let wordIndices = bits.splitIntoChunks(ofSize: Mnemonic.WordList.sizeLog2)
            .map { UInt11(bitArray: $0)! }
            .map { $0.asInt }

        let mnemonic = wordIndices.map { words[$0] }

        try validateChecksumOf(mnemonic: mnemonic, language: language)
        return mnemonic
    }

    static func securelyGenerateBytes(count: Int) throws -> Data {
        var randomBytes = [UInt8](repeating: 0, count: count)
        let statusRaw = SecRandomCopyBytes(kSecRandomDefault, count, &randomBytes) as OSStatus
        guard statusRaw == errSecSuccess else { throw MnemonicError.randomBytesError }
        return Data(randomBytes)
    }
}

// MARK: To Seed
public extension Mnemonic {
    /// Pass a trivial closure: `{ _ in }` to `validateChecksum` if you would like to opt-out of checksum validation.
    static func seed(
        mnemonic words: [String],
        passphrase: String = "",
        validateChecksum: (([String]) throws -> Void) = { try Mnemonic.validateChecksumDerivingLanguageOf(mnemonic: $0) }
    ) rethrows -> Data {

        try validateChecksum(words)

        let mnemonic = words.joined(separator: " ").decomposedStringWithCompatibilityMapping
        let salt = ("mnemonic" + passphrase).decomposedStringWithCompatibilityMapping.data(using: .utf8)!
        let seed = _Key.deriveKey(password: mnemonic, salt: salt, iterations: 2048, keyLength: 64)
        return seed
    }
}
