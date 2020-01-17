import Foundation

// Duplicates the top stack item.
public struct OpDuplicate: OpCodeProtocol {
    public var value: UInt8 { return 0x76 }
    public var name: String { return "OP_DUP" }

    // input : x
    // output : x x
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(1)
        let x: Data = context.data(at: -1)
        try context.pushToStack(x)
    }
}
