import Foundation

// If a or b is not "" (null string), the output is 1. Otherwise 0.
public struct OpBoolOr: OpCodeProtocol {
    public var value: UInt8 { return 0x9b }
    public var name: String { return "OP_BOOLOR" }

    // (x1 x2 -- out)
     public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(2)

        let x1 = context.data(at: -2)
        let x2 = context.data(at: -1)
        let output: Bool = x1 != Data() || x2 != Data()

        context.stack.removeLast()
        context.stack.removeLast()
        context.pushToStack(output)
    }
}
