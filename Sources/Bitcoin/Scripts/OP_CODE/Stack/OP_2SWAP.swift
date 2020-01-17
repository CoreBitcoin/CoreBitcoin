import Foundation

// Swaps the top two pairs of items.
public struct Op2Swap: OpCodeProtocol {
    public var value: UInt8 { return 0x72 }
    public var name: String { return "OP_2SWAP" }

    // input : x1 x2 x3 x4
    // output : x3 x4 x1 x2
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(4)
        context.swapDataAt(i: -4, j: -2)
        context.swapDataAt(i: -3, j: -1)
    }
}
