import Foundation

/// Helper model that builds an unsigned transaction
/// ```
/// // Builds an unsigned transaction from a transaction plan.
/// let unsignedTx = TransactionBuilder.build(from: plan, toAddress: toAddress, changeAddress: changeAddress)
/// ```
public struct TransactionBuilder {
    /// Builds an unsigned transaction from a transaction plan.
    ///
    /// - Parameters:
    ///   - plan: Transaction plan to build a transaction
    ///   - toAddress: Address to send the amount
    ///   - changeAddress: Address to receive the change
    /// - Returns: The transaction whose inputs are not signed.
    public static func build(from plan: TransactionPlan, toAddress: Address, changeAddress: Address) -> Transaction {
        let toLockScript: Data = Script(address: toAddress)!.data
        var outputs: [TransactionOutput] = [
            TransactionOutput(value: plan.amount, lockingScript: toLockScript)
        ]
        if plan.change > 0 {
            let changeLockScript: Data = Script(address: changeAddress)!.data
            outputs.append(
                TransactionOutput(value: plan.change, lockingScript: changeLockScript)
            )
        }

        let unsignedInputs: [TransactionInput] = plan.unspentTransactions.map {
            TransactionInput(
                previousOutput: $0.outpoint,
                signatureScript: Data(),
                sequence: UInt32.max
            )
        }

        // TODO: add witnesses
        let witnesses: [TransactionWitness] = []
        return Transaction(version: 1, inputs: unsignedInputs, outputs: outputs, witnesses: witnesses, lockTime: 0)
    }
}
