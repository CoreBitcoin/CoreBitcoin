import Foundation

public typealias MnemonicError = Mnemonic.Error

public extension Mnemonic {
    enum Error: Swift.Error {
        case randomBytesError
        case unsupportedByteCountOfEntropy(got: Int)
        indirect case validationError(ValidationError)
    }
}

public extension Mnemonic.Error {
    enum ValidationError: Swift.Error {
        case badWordCount(expectedAnyOf: [Int], butGot: Int)
        case wordNotInList(String, language: Mnemonic.Language)
        case unableToDeriveLanguageFrom(words: [String])
        case checksumMismatch
    }
}
