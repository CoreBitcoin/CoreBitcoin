import Foundation

extension Address {
    /// An object that represents the hash size of an address.
    ///
    ///  Legacy address size is 20 bytes (160 bits).
    ///  Bech32 p2wpkh address size is 20 bytes (160 bits).
    ///  Bech32 p2wpsh address size is 32 bytes (256 bits).
    public struct HashSize {
        public let rawValue: UInt8
        /// Creates a new HashSize instance with 1 bit value.
        ///
        /// - Parameter rawValue: UInt8 value of the bit.
        public init?(rawValue: UInt8) {
            guard [0, 1].contains(rawValue) else {
                return nil
            }
            self.rawValue = rawValue
        }

        /// Creates a new HashSize instance with the actual size of the hash.
        ///
        /// - Parameter sizeInBits: UInt8 value of the size of the hash in bits.
        public init?(sizeInBits: Int) {
            switch sizeInBits {
            case 160: rawValue = 0
            case 256: rawValue = 1
            default: return nil
            }
        }
    }
}

extension Address.HashSize {
    /// Hash size in bits
    public var sizeInBits: Int {
        switch rawValue {
        case 0: return 160
        case 1: return 256
        default: fatalError("Unsupported size bits")
        }
    }

    /// Hash size in bytes
    public var sizeInBytes: Int {
        return sizeInBits / 8
    }
}

extension Address.HashSize: Equatable {
    // swiftlint:disable operator_whitespace
    public static func ==(lhs: Address.HashSize, rhs: Address.HashSize) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension Address.HashSize {
    public static let bits160: Address.HashSize = Address.HashSize(sizeInBits: 160)!
    public static let bits256: Address.HashSize = Address.HashSize(sizeInBits: 256)!
}
