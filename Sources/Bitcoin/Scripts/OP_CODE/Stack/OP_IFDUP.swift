import Foundation

// If the top stack value is not 0, duplicate it.
public struct OpIfDup: OpCodeProtocol {
    public var value: UInt8 { return 0x73 }
    public var name: String { return "OP_IFDUP" }

    // input : x
    // output : x / x x    
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(1)
        if context.bool(at: -1) {
            context.stack.append(context.data(at: -1))
        }
    }
}
