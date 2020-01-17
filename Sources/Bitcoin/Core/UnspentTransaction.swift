import Foundation

public struct UnspentTransaction {
    public let output: TransactionOutput
    public let outpoint: TransactionOutPoint

    public init(output: TransactionOutput, outpoint: TransactionOutPoint) {
        self.output = output
        self.outpoint = outpoint
    }
}
