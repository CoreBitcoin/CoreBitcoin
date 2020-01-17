import XCTest
@testable import Bitcoin

class OpCodeFactoryTests: XCTestCase {
    func testGetWithValue() {
        assert(OpCodeFactory.get(with: 0x00), OpCode.OP_0)
        assert(OpCodeFactory.get(with: 0x4c), OpCode.OP_PUSHDATA1)
        assert(OpCodeFactory.get(with: 0x4f), OpCode.OP_1NEGATE)
        assert(OpCodeFactory.get(with: 0x51), OpCode.OP_1)
        assert(OpCodeFactory.get(with: 0xa9), OpCode.OP_HASH160)
        assert(OpCodeFactory.get(with: 0xac), OpCode.OP_CHECKSIG)
        assert(OpCodeFactory.get(with: 0xff), OpCode.OP_INVALIDOPCODE)
    }

    func testGetWithName() {
        assert(OpCodeFactory.get(with: "OP_0"), OpCode.OP_0)
        assert(OpCodeFactory.get(with: "OP_PUSHDATA1"), OpCode.OP_PUSHDATA1)
        assert(OpCodeFactory.get(with: "OP_1NEGATE"), OpCode.OP_1NEGATE)
        assert(OpCodeFactory.get(with: "OP_1"), OpCode.OP_1)
        assert(OpCodeFactory.get(with: "OP_HASH160"), OpCode.OP_HASH160)
        assert(OpCodeFactory.get(with: "OP_CHECKSIG"), OpCode.OP_CHECKSIG)
        assert(OpCodeFactory.get(with: "OP_INVALIDOPCODE"), OpCode.OP_INVALIDOPCODE)
    }

    func testOpCodeForSmallInteger() {
        assert(OpCodeFactory.opcode(for: -1), OpCode.OP_1NEGATE)
        assert(OpCodeFactory.opcode(for: 0), OpCode.OP_0)
        assert(OpCodeFactory.opcode(for: 1), OpCode.OP_1)
        assert(OpCodeFactory.opcode(for: 8), OpCode.OP_8)
        assert(OpCodeFactory.opcode(for: 16), OpCode.OP_16)
        assert(OpCodeFactory.opcode(for: 17), OpCode.OP_INVALIDOPCODE)
        assert(OpCodeFactory.opcode(for: Int.min), OpCode.OP_INVALIDOPCODE)
        assert(OpCodeFactory.opcode(for: Int.max), OpCode.OP_INVALIDOPCODE)
    }

    func testSmallIntegerFromOpcode() {
        XCTAssertEqual(OpCodeFactory.smallInteger(from: OpCode.OP_1NEGATE), -1)
        XCTAssertEqual(OpCodeFactory.smallInteger(from: OpCode.OP_0), 0)
        XCTAssertEqual(OpCodeFactory.smallInteger(from: OpCode.OP_1), 1)
        XCTAssertEqual(OpCodeFactory.smallInteger(from: OpCode.OP_8), 8)
        XCTAssertEqual(OpCodeFactory.smallInteger(from: OpCode.OP_16), 16)
        XCTAssertEqual(OpCodeFactory.smallInteger(from: OpCode.OP_INVALIDOPCODE), Int.max)
    }

    private func assert(_ lhs: OpCodeProtocol, _ rhs: OpCodeProtocol) {
        XCTAssertEqual(lhs.name, rhs.name)
        XCTAssertEqual(lhs.value, rhs.value)
    }
}
