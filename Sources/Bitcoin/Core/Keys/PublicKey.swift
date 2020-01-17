import Foundation

public struct PublicKey {
    public let data: Data
    public var pubKeyHash: Data {
        return Crypto.sha256ripemd160(data)
    }
    public let network: Network
    public let isCompressed: Bool

    public init(bytes data: Data, network: Network) {
        self.data = data
        self.network = network
        let header = data[0]
        self.isCompressed = (header == 0x02 || header == 0x03)
    }
}

extension PublicKey {
    public func toAddress() -> Address {
        return try! Address(data: pubKeyHash, hashType: .pubKeyHash, network: network)
    }
}

extension PublicKey: Equatable {
    public static func == (lhs: PublicKey, rhs: PublicKey) -> Bool {
        return lhs.network == rhs.network && lhs.data == rhs.data
    }
}

extension PublicKey: CustomStringConvertible {
    public var description: String {
        return data.hex
    }
}
