import Foundation

// Marks transaction as invalid if the relative lock time of the input (enforced by BIP 0068 with nSequence) is not equal to or longer than the value of the top stack item. The precise semantics are described in BIP 0112.
public struct OpCheckSequenceVerify: OpCodeProtocol {
    public var value: UInt8 { return 0xb2 }
    public var name: String { return "OP_CHECKSEQUENCEVERIFY" }

    // input : x
    // output : x / fail
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(1)

        // nLockTime should be Int5
        // reference: https://github.com/Bitcoin-ABC/bitcoin-abc/blob/73c5e7532e19b8f35fcf73255cd1d0df67607cd2/src/script/interpreter.cpp#L420
        let nSequenceTmp = try context.number(at: -1)
        guard nSequenceTmp >= 0 else {
            throw OpCodeExecutionError.error("NEGATIVE_LOCKTIME")
        }
        let nSequence: UInt32 = UInt32(nSequenceTmp)

        guard let tx = context.transaction, let txin = context.txinToVerify else {
            throw OpCodeExecutionError.error("OP_CHECKLOCKTIMEVERIFY must have a transaction in context.")
        }

        let txToSequence = txin.sequence
        guard tx.version > 1 else {
            throw OpCodeExecutionError.error("Transaction's version number is not set high enough to trigger BIP 68 rules.")
        }

        let SEQUENCE_LOCKTIME_DISABLE_FLAG: UInt32 = (1 << 31)
        guard txToSequence & SEQUENCE_LOCKTIME_DISABLE_FLAG == 0 else {
            throw OpCodeExecutionError.error("SEQUENCE_LOCKTIME_DISABLE_FLAG is set.")
        }

        let SEQUENCE_LOCKTIME_TYPE_FLAG: UInt32 = (1 << 22)
        let SEQUENCE_LOCKTIME_MASK: UInt32 = 0x0000ffff
        let nLockTimeMask: UInt32 = SEQUENCE_LOCKTIME_TYPE_FLAG | SEQUENCE_LOCKTIME_MASK
        let txToSequenceMasked: UInt32 = txToSequence & nLockTimeMask
        let nSequenceMasked: UInt32 = nSequence & nLockTimeMask

        guard (txToSequenceMasked < SEQUENCE_LOCKTIME_TYPE_FLAG && nSequenceMasked < SEQUENCE_LOCKTIME_TYPE_FLAG) ||
            (txToSequenceMasked >= SEQUENCE_LOCKTIME_TYPE_FLAG && nSequenceMasked >= SEQUENCE_LOCKTIME_TYPE_FLAG) else {
                throw OpCodeExecutionError.error("txToSequenceMasked and nSequenceMasked should be the same kind.")
        }

        guard nSequence <= txToSequenceMasked  else {
            throw OpCodeExecutionError.error("The top stack item is greater than the transaction's nSequence field")
        }
    }
}
