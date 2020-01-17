import Foundation

// The top two items on the stack are swapped.
public struct OpSwap: OpCodeProtocol {
    public var value: UInt8 { return 0x7c }
    public var name: String { return "OP_SWAP" }

    // input : x1 x2
    // output : x2 x1
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(2)
        context.swapDataAt(i: -2, j: -1)
    }
}
