import Foundation

// If both a and b are not "" (null string), the output is 1. Otherwise 0.
public struct OpBoolAnd: OpCodeProtocol {
    public var value: UInt8 { return 0x9a }
    public var name: String { return "OP_BOOLAND" }

    // (x1 x2 -- out)
     public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(2)

        let x1 = context.data(at: -2)
        let x2 = context.data(at: -1)
        let output: Bool = x1 != Data() && x2 != Data()

        context.stack.removeLast()
        context.stack.removeLast()
        context.pushToStack(output)
    }
}
