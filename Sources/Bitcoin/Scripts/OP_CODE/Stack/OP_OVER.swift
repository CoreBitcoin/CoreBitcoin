import Foundation

// Copies the second-to-top stack item to the top.
public struct OpOver: OpCodeProtocol {
    public var value: UInt8 { return 0x78 }
    public var name: String { return "OP_OVER" }

    // input : x1 x2
    // output : x1 x2 x1
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(2)
        let x: Data = context.data(at: -2)
        context.stack.append(x)
    }
}
