import Foundation

extension Address {
    // Bech32 supported address version
    // Version is between 0 and 16 but we support only version 0 (current one).
    public static var versionByte: UInt8 {
        return 0
    }
    // Bech32 encoded address format
    public var bech32: String {
        let regroupedData = try! Address.regroupBits(from: 8, to: 5, pad: true, data: data)
        return Bech32.encode(hrp: network.hrp, payload: [Address.versionByte] + regroupedData)
    }

    /// Creates a new Address instance with the bech32 encoding.
    ///
    /// ```
    /// let address = try Address("bc1qar0srrr7xfkvy5l643lydnw9re59gtzzwf5mdq")
    /// ```
    ///
    /// - Parameter bech32: Bech32 encoded String value to use as the source of the new instance.
    public init(_ bech32: String) throws {
        // prefix validation and decode
        let decoded = try Bech32.decode(bech32)

        switch decoded.hrp {
        case Network.mainnet.hrp:
            network = .mainnet
        case Network.testnet.hrp:
            network = .testnet
        default:
            throw AddressError.invalid
        }

        let payload = decoded.data
        let version = payload[0]
        guard version == Address.versionByte else {
            throw AddressError.invalid
        }

        self.data = try Address.regroupBits(from: 5, to: 8, pad: false, data: payload.dropFirst())
        guard let size = HashSize(sizeInBits: data.count * 8) else {
            throw AddressError.invalidDataSize
        }

        self.hashSize = size
        switch self.hashSize {
        case .bits160:
            self.hashType = .pubKeyHash
        case .bits256:
            self.hashType = .scriptHash
        default:
            throw AddressError.invalid
        }
    }

    // Regroup bits
    private static func regroupBits(from: Int, to: Int, pad: Bool, data: Data) throws -> Data {
        var acc: Int = 0
        var bits: Int = 0
        let maxv: Int = (1 << to) - 1
        let maxAcc: Int = (1 << (from + to - 1)) - 1
        var odata = Data()
        for byte in data {
            acc = ((acc << from) | Int(byte)) & maxAcc
            bits += from
            while bits >= to {
                bits -= to
                odata.append(UInt8((acc >> bits) & maxv))
            }
        }
        if pad {
            if bits != 0 {
                odata.append(UInt8((acc << (to - bits)) & maxv))
            }
        } else if (bits >= from || ((acc << (to - bits)) & maxv) != 0) {
            throw AddressError.bitsConversionFailed
        }
        return odata
    }
}
