import Foundation

// Puts the input onto the top of the alt stack. Removes it from the main stack.
public struct OpToAltStack: OpCodeProtocol {
    public var value: UInt8 { return 0x6b }
    public var name: String { return "OP_TOALTSTACK" }

    // input : x
    // output : (alt)x
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(1)
        let x: Data = context.stack.removeLast()
        context.altStack.append(x)
    }
}
