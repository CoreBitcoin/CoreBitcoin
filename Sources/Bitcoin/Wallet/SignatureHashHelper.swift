import Foundation

public protocol SignatureHashHelper {
    var hashType: SighashType { get }
    /// Create the signature hash of the transaction
    ///
    /// - Parameters:
    ///   - tx: Transaction to be signed
    ///   - utxoOutput: TransactionOutput to be signed
    ///   - inputIndex: The index of the transaction output to be signed
    /// - Returns: The signature hash for the transaction to be signed.
    func createSignatureHash(of tx: Transaction, for utxoOutput: TransactionOutput, inputIndex: Int) -> Data
}
