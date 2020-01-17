import Foundation

public enum TransactionSignerError: Error {
    case noKeyFound
}

/// Helper class that performs Bitcoin transaction signing.
/// ```
/// // Initialize a signer
/// let signer = TransactionSigner(unspentTransactions: unspentTransactions, transaction: transaction, sighashHelper: sighashHelper)
///
/// // Sign the unsigned transaction
/// let signedTx = signer.sign(with: privKeys)
/// ```
public final class TransactionSigner {
    /// Unspent transactions to be signed.
    public let unspentTransactions: [UnspentTransaction]
    /// Transaction being signed.
    public let transaction: Transaction
    /// Signature Hash Helper
    public let sighashHelper: SignatureHashHelper

    /// List of signed inputs.
    private var signedInputs: [TransactionInput]
    /// Signed transaction
    private var signedTransaction: Transaction {
        return Transaction(
            version: transaction.version,
            inputs: signedInputs,
            outputs: transaction.outputs,
            witnesses: transaction.witnesses,
            lockTime: transaction.lockTime)
    }

    public init(unspentTransactions: [UnspentTransaction], transaction: Transaction, sighashHelper: SignatureHashHelper) {
        self.unspentTransactions = unspentTransactions
        self.transaction = transaction
        self.signedInputs = transaction.inputs
        self.sighashHelper = sighashHelper
    }

    /// Sign the transaction with keys of the unspent transactions
    ///
    /// - Parameters:
    ///   - keys: the private keys of the unspent transactions
    /// - Returns: A signed transaction. Error is thrown when the signing failed.
    public func sign(with keys: [PrivateKey]) throws -> Transaction {
        for (i, unspentTransaction) in unspentTransactions.enumerated() {
            // Select key
            let utxo = unspentTransaction.output
            let pubKeyHash: Data = Script.getPublicKeyHash(from: utxo.lockingScript)

            guard let key = keys.first(where: { $0.publicKey().pubKeyHash == pubKeyHash }) else {
                throw TransactionSignerError.noKeyFound
            }

            // Sign transaction hash
            let sighash: Data = sighashHelper.createSignatureHash(of: transaction, for: utxo, inputIndex: i)
            let signature: Data = try Crypto.sign(sighash, privateKey: key)
            let txin = signedInputs[i]
            let pubkey = key.publicKey()

            // Create Signature Script
            let sigWithHashType: Data = signature + [sighashHelper.hashType.uint8]
            let unlockingScript: Script = try Script()
                .appendData(sigWithHashType)
                .appendData(pubkey.data)

            // Update TransactionInput
            signedInputs[i] = TransactionInput(previousOutput: txin.previousOutput, signatureScript: unlockingScript.data, sequence: txin.sequence)
        }
        return signedTransaction
    }
}
