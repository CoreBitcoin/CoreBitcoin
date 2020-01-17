import XCTest
@testable import Bitcoin

class BlockMessageTests: XCTestCase {
    fileprivate func loadRawBlock(named name: String) throws -> BlockMessage {
        let data: Data
        let sourceFile = URL(fileURLWithPath: #file)
        let directory = sourceFile.deletingLastPathComponent()
        let fileURL = directory
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Resources", isDirectory: true)
            .appendingPathComponent(name)
            .appendingPathExtension("raw")
        data = try Data(contentsOf: fileURL)
        return BlockMessage.deserialize(data)
    }

    func testComputeMerkleRoot() throws {
        let block1 = try loadRawBlock(named: "block1")
        XCTAssertEqual(block1.computeMerkleRoot(), block1.merkleRoot)

        let block413567 = try loadRawBlock(named: "block413567")
        XCTAssertEqual(block413567.computeMerkleRoot(), block413567.merkleRoot)
    }

}
