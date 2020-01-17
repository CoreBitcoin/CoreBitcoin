import Foundation

// Duplicates the top two stack items.
public struct Op2Duplicate: OpCodeProtocol {
    public var value: UInt8 { return 0x6e }
    public var name: String { return "OP_2DUP" }

    // input : x1 x2
    // output : x1 x2 x1 x2
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(2)
        let x1: Data = context.data(at: -2)
        let x2: Data = context.data(at: -1)
        try context.pushToStack(x1)
        try context.pushToStack(x2)
    }
}
