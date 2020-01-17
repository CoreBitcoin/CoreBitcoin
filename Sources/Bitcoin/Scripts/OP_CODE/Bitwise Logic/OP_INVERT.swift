import Foundation

// Flips all of the bits in the input. disabled.
public struct OpInvert: OpCodeProtocol {
    public var value: UInt8 { return 0x83 }
    public var name: String { return "OP_INVERT" }

    public func isEnabled() -> Bool {
        return false
    }

    // input : in
    // output : out
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(1)

        let x = context.stack.removeLast()
        let output: Data = Data(from: x.map { ~$0 })
        context.stack.append(output)
    }
}
