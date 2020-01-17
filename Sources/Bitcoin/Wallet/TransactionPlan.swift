import Foundation

/// Describes a preliminary transaction plan.
public struct TransactionPlan {
    /// Selected Unspent transactions.
    public let unspentTransactions: [UnspentTransaction]
    /// Amount to be received at the other end.
    public let amount: UInt64
    /// Estimated transaction fee.
    public let fee: UInt64
    /// Change.
    public let change: UInt64

    public init(unspentTransactions: [UnspentTransaction], amount: UInt64, fee: UInt64, change: UInt64) {
        self.unspentTransactions = unspentTransactions
        self.amount = amount
        self.fee = fee
        self.change = change
    }
}
