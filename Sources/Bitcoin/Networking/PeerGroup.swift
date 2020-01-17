import Foundation

public class PeerGroup: PeerDelegate {
    public let blockChain: BlockChain
    public let maxConnections: Int

    public weak var delegate: PeerGroupDelegate?

    var peers = [String: Peer]()

    private var filters = [Data]()
    private var transactions = [Transaction]()

    public init(blockChain: BlockChain, maxConnections: Int = 1) {
        self.blockChain = blockChain
        self.maxConnections = maxConnections
    }

    public func start() {
        let network = blockChain.network
        for _ in peers.count..<maxConnections {
            // TODO: Why [1] , 1 is always "testnet-seed.bitcoin.jonasschnelli.ch". in .testnet
            // All peers will connect to that server?
            // maybe do a random or connect to different seed server based on array index ?
            let peer = Peer(host: network.dnsSeeds[1], network: network)
            peer.delegate = self
            peer.connect()

            peers[peer.host] = peer
        }

        delegate?.peerGroupDidStart(self)
    }

    public func stop() {
        for peer in peers.values {
            peer.delegate = nil
            peer.disconnect()
        }
        peers.removeAll()

        delegate?.peerGroupDidStop(self)
    }

    // filter: pubkey, pubkeyhash, scripthash, etc...
    public func addFilter(_ filter: Data) {
        filters.append(filter)
    }

    public func sendTransaction(transaction: Transaction) {
        if let peer = peers.values.first {
            peer.sendTransaction(transaction: transaction)
        } else {
            transactions.append(transaction)
            start()
        }
    }

    public func peerDidConnect(_ peer: Peer) {
        if peers.filter({ $0.value.context.isSyncing }).isEmpty {
            let latestBlockHash = blockChain.latestBlockHash()
            peer.startSync(filters: filters, latestBlockHash: latestBlockHash)
        }
        if !transactions.isEmpty {
            for transaction in transactions {
                peer.sendTransaction(transaction: transaction)
            }
        }
    }

    public func peerDidDisconnect(_ peer: Peer) {
        peers[peer.host] = nil
        start()
    }

    public func peer(_ peer: Peer, didReceiveVersionMessage message: VersionMessage) {
       // print(message.userAgent?.value)
    }

    public func peer(_ peer: Peer, didReceiveMerkleBlockMessage message: MerkleBlockMessage, hash: Data) {
        guard ProofOfWork.isValidProofOfWork(blockHash: hash, bits: message.bits) else {
            print("insufficient proof of work!")
            return
        }
        do {
            let root: Data = try MerkleTree.calculateMerkleRoot(numberOfHashes: UInt32(message.numberOfHashes.underlyingValue),
                                                      hashes: message.hashes,
                                                      numberOfFlags: UInt32(message.numberOfFlags.underlyingValue),
                                                      flags: message.flags,
                                                      totalTransactions: message.totalTransactions)
            if root != message.merkleRoot {
                print("not match merkelroot!")
                return
            }
        } catch {
            print("merkleroot build failed!")
            print("time: \(NSDate(timeIntervalSince1970: Double(message.timestamp)))")
            print("merkleRoot: \(message.merkleRoot.hex)")
            print("hash: \(Data(hash.reversed()).hex)")
            return
        }
        try! blockChain.addMerkleBlock(message, hash: hash)
    }

    public func peer(_ peer: Peer, didReceiveTransaction transaction: Transaction, hash: Data) {
        try! blockChain.addTransaction(transaction, hash: hash)
        delegate?.peerGroupDidReceiveTransaction(self)
    }
}

public protocol PeerGroupDelegate: class {
    func peerGroupDidStart(_ peerGroup: PeerGroup)
    func peerGroupDidStop(_ peerGroup: PeerGroup)
    func peerGroupDidReceiveTransaction(_ peerGroup: PeerGroup)
}

extension PeerGroupDelegate {
    public func peerGroupDidStart(_ peerGroup: PeerGroup) {}
    public func peerGroupDidStop(_ peerGroup: PeerGroup) {}
    public func peerGroupDidReceiveTransaction(_ peerGroup: PeerGroup) {}
}
