import Foundation

// Puts the input onto the top of the main stack. Removes it from the alt stack.
public struct OpFromAltStack: OpCodeProtocol {
    public var value: UInt8 { return 0x6c }
    public var name: String { return "OP_FROMALTSTACK" }

    // input : (alt)x
    // output : x
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertAltStackHeightGreaterThanOrEqual(1)
        let x: Data = context.altStack.removeLast()
        context.stack.append(x)
    }
}
