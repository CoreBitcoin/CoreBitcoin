import Foundation

// The top three items on the stack are rotated to the left.
public struct OpRot: OpCodeProtocol {
    public var value: UInt8 { return 0x7b }
    public var name: String { return "OP_ROT" }

    // input : x1 x2 x3
    // output : x2 x3 x1
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(3)
        context.swapDataAt(i: -3, j: -2)
        context.swapDataAt(i: -2, j: -1)
    }
}
