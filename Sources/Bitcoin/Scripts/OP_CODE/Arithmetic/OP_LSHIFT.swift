import Foundation

// (x y -- x<<y) disabled.
public struct OpLShift: OpCodeProtocol {
    public var value: UInt8 { return 0x98 }
    public var name: String { return "OP_LSHIFT" }

    public func isEnabled() -> Bool {
        return false
    }

    // (x1 x2 -- out)
     public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(2)

        let x1 = try context.number(at: -2)
        let x2 = try context.number(at: -1)

        context.stack.removeLast()
        context.stack.removeLast()
        try context.pushToStack(x1 << x2)
    }
}
