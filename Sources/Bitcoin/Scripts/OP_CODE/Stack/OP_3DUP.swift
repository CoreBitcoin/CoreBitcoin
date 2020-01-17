import Foundation

// Duplicates the top three stack items.
public struct Op3Duplicate: OpCodeProtocol {
    public var value: UInt8 { return 0x6f }
    public var name: String { return "OP_3DUP" }

    // input : x1 x2 x3
    // output : x1 x2 x3 x1 x2 x3
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(3)
        let x1: Data = context.data(at: -3)
        let x2: Data = context.data(at: -2)
        let x3: Data = context.data(at: -1)
        try context.pushToStack(x1)
        try context.pushToStack(x2)
        try context.pushToStack(x3)
    }
}
