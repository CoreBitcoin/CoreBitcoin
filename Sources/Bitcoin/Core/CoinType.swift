import Foundation

/// BIP44 cointype value
public struct CoinType {
    /// BIP44 cointype value
    public let index: UInt32
    /// Coin symbol
    public let symbol: String
    /// Coin name
    public let name: String

    public init(_ index: UInt32, _ symbol: String, _ name: String) {
        self.index = index
        self.symbol = symbol
        self.name = name
    }
}

extension CoinType: Equatable {
    // swiftlint:disable operator_whitespace
    public static func ==(lhs: CoinType, rhs: CoinType) -> Bool {
        return lhs.index == rhs.index
            && lhs.symbol == rhs.symbol
            && lhs.name == rhs.name
    }
}

public extension CoinType {
    /// CoinType index list : https://github.com/satoshilabs/slips/blob/master/slip-0044.md
    static let btc = CoinType(0, "BTC", "Bitcoin")
    static let testnet = CoinType(1, "", "Testnet (all coins)")
}
