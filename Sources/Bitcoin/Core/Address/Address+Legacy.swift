import Foundation

public struct Address {
    public let data: Data
    public let network: Network

    // Bitcoin Address parameter
    public let hashType: HashType
    public let hashSize: HashSize

    // Base58Check encoded bitcoin address format
    public var legacy: String {
        switch hashType {
        case .pubKeyHash:
            return Base58Check.encode([network.pubKeyHash] + data)
        case .scriptHash:
            return Base58Check.encode([network.pubKeyHash] + data)
        }
    }

    /// Creates a new Address instance with raw parameters.
    ///
    /// This initializer performs hash size validation.
    /// ```
    /// // Initialize address from raw parameters
    /// let address = try Address(data: pubkeyHash,
    ///                            type: .pubkeyHash,
    ///                            network: .testnet)
    /// ```
    ///
    /// - Parameters:
    ///   - data: The hash of public key or script
    ///   - hashType: .pubkeyHash or .scriptHash
    ///   - network: .testnet or .mainnet.
    public init(data: Data, hashType: HashType, network: Network) throws {
        guard let hashSize = HashSize(sizeInBits: data.count * 8) else {
            throw AddressError.invalidDataSize
        }

        self.data = data
        self.hashType = hashType
        self.hashSize = hashSize
        self.network = network
    }

    /// Creates a new Address instance with Base58Check encoding.
    ///
    /// The network will be .mainnet or .testnet. This initializer performs
    /// base58check and hash size validation.
    /// ```
    /// let address = try Address(legacy: "1AC4gh14wwZPULVPCdxUkgqbtPvC92PQPN")
    /// ```
    ///
    /// - Parameter legacy: Base58Check encoded String value to use as the source of the new instance.
    public init(legacy: String) throws {
        // Hash size is 160 bits
        self.hashSize = .bits160

        // Base58Check decode
        guard let pubKeyHash = Base58Check.decode(legacy) else {
            throw AddressError.invalid
        }

        let networkVersionByte = pubKeyHash[0]

        // Network
        switch networkVersionByte {
        case Network.mainnet.pubKeyHash, Network.mainnet.scriptHash:
            network = .mainnet
        case Network.testnet.pubKeyHash, Network.testnet.scriptHash:
            network = .testnet
        default:
            throw AddressError.invalidVersionByte
        }

        // Hash type
        switch networkVersionByte {
        case Network.mainnet.pubKeyHash, Network.testnet.pubKeyHash:
            hashType = .pubKeyHash
        case Network.mainnet.scriptHash, Network.testnet.scriptHash:
            hashType = .scriptHash
        default:
            throw AddressError.invalidVersionByte
        }

        self.data = pubKeyHash.dropFirst()

        // validate data size
        guard data.count == hashSize.sizeInBytes else {
            throw AddressError.invalid
        }
    }
}

extension Address: Equatable {
    public static func == (lhs: Address, rhs: Address) -> Bool {
        return lhs.data == rhs.data
            && lhs.hashType == rhs.hashType
            && lhs.hashSize == rhs.hashSize
    }
}
