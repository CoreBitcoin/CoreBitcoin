import Foundation

struct MerkleTree {
    enum MerkleError: Error {
        case noEnoughParent
        case noEnoughHash
        case duplicateHash // CVE-2012-2459
        case invalidNumberOfHashes
        case invalidNumberOfFlags
        case nullHash
        case unnecessaryBits
    }

    static let bitMask: [UInt8] = [0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80]

    static func calculateMerkleRoot(numberOfHashes: UInt32,
                                    hashes: [Data],
                                    numberOfFlags: UInt32,
                                    flags: [UInt8],
                                    totalTransactions: UInt32) throws -> Data {

        if numberOfHashes != hashes.count {
            throw MerkleError.invalidNumberOfHashes
        }
        if flags.count < numberOfFlags / 8 {
            throw MerkleError.invalidNumberOfFlags
        }

        var bitsUsed = 0
        var hashesUsed = 0
        var matchedHashes = [Data]()

        // Start at the root and travel down the leaf node
        var height = 0
        while getTreeWidth(height, txCount: totalTransactions) > 1 {
            height += 1
        }
        let merkleRoot = try parseBranch(totalTransactions: totalTransactions, hashes: hashes, flags: flags, height: height, pos: 0, matchedHashes: &matchedHashes, bitsUsed: &bitsUsed, hashesUsed: &hashesUsed)
        if (bitsUsed + 7) / 8 != flags.count {
            throw MerkleError.unnecessaryBits
        }
        return merkleRoot
    }

    static func parseBranch(totalTransactions: UInt32, hashes: [Data], flags: [UInt8], height: Int, pos: Int, matchedHashes: inout [Data], bitsUsed: inout Int, hashesUsed: inout Int) throws -> Data {
        if bitsUsed >= flags.count * 8 {
            throw MerkleError.noEnoughParent // notEnoughBits
        }
        let parentOfMatch = checkBitLE(data: flags, index: bitsUsed)
        bitsUsed += 1
        if height == 0 || !parentOfMatch {
            guard hashesUsed < hashes.count else {
                // overflowed the hash array - failure
                throw MerkleError.noEnoughHash
            }
            if height == 0, parentOfMatch {
                matchedHashes.append(hashes[hashesUsed])
            }
            hashesUsed += 1
            return hashes[hashesUsed - 1]
        }
        // down to next level
        let right: Data
        let left = try parseBranch(totalTransactions: totalTransactions, hashes: hashes, flags: flags, height: height - 1, pos: pos * 2, matchedHashes: &matchedHashes, bitsUsed: &bitsUsed, hashesUsed: &hashesUsed)
        if pos * 2 + 1 < getTreeWidth(height - 1, txCount: totalTransactions) {
            right = try parseBranch(totalTransactions: totalTransactions, hashes: hashes, flags: flags, height: height - 1, pos: pos * 2 + 1, matchedHashes: &matchedHashes, bitsUsed: &bitsUsed, hashesUsed: &hashesUsed)
        } else {
            right = left
        }

        return Crypto.sha256sha256(left + right)
    }

    static func checkBitLE(data: [UInt8], index: Int) -> Bool {
        return (data[Int(index >> 3)] & bitMask[Int(7 & index)]) != 0
    }

    static func getTreeWidth(_ height: Int, txCount: UInt32) -> Int {
        return (Int(txCount) + (1 << height) - 1) >> height
    }

    static func buildMerkleRoot(numberOfHashes: UInt32, hashes: [Data], numberOfFlags: UInt32, flags: [UInt8], totalTransactions: UInt32) throws -> Data {
        if numberOfHashes != hashes.count {
            throw MerkleError.invalidNumberOfHashes
        }
        if flags.count < numberOfFlags / 8 {
            throw MerkleError.invalidNumberOfFlags
        }
        let parents: [Bool] = (0 ..< Int(numberOfFlags)).compactMap({
            return (flags[$0 / 8] & UInt8(1 << ($0 % 8))) != 0
        })
        let maxdepth: UInt = UInt(ceil_log2(totalTransactions))
        var hashIterator = hashes.makeIterator()
        var parentIterator = parents.makeIterator()
        let root = try buildPartialMerkleTree(hashIterator: &hashIterator, parentIterator: &parentIterator, depth: 0, maxdepth: maxdepth)
        guard let h = root.hash else { throw MerkleError.nullHash }
        return h
    }

    struct PartialMerkleTree {
        var hash: Data?
        // zero size if depth is maxdepth
        // leaf[0]: left, leaf[1]: right
        var leaf: [PartialMerkleTree] = []
        init(hash: Data, leafL: PartialMerkleTree, leafR: PartialMerkleTree) {
            self.hash = hash
            leaf.append(leafL)
            leaf.append(leafR)
        }
        init(hash: Data) {
            self.hash = hash
        }
    }

    private static func buildPartialMerkleTree(
        hashIterator: inout IndexingIterator<[Data]>,
        parentIterator: inout IndexingIterator<[Bool]>,
        depth: UInt, maxdepth: UInt) throws -> PartialMerkleTree {
        guard let parent = parentIterator.next() else { throw MerkleError.noEnoughParent }
        if !parent || maxdepth <= depth {
            // leaf
            guard let hash = hashIterator.next() else { throw MerkleError.noEnoughHash }
            return PartialMerkleTree(hash: hash)
        } else {
            // vertex
            let left: PartialMerkleTree = try buildPartialMerkleTree(hashIterator: &hashIterator, parentIterator: &parentIterator, depth: depth + 1, maxdepth: maxdepth)
            let right: PartialMerkleTree = try buildPartialMerkleTree(hashIterator: &hashIterator, parentIterator: &parentIterator, depth: depth + 1, maxdepth: maxdepth)
            if let h0 = left.hash, let h1 = right.hash {
                if h0 == h1 {
                    // CVE-2012-2459
                    throw MerkleError.duplicateHash
                }
                let hash = Crypto.sha256sha256(h0 + h1)
                return PartialMerkleTree(hash: hash, leafL: left, leafR: right)
            } else {
                throw MerkleError.nullHash
            }
        }
    }
}
