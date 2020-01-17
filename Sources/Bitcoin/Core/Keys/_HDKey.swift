import Foundation
import secp256k1

class _HDKey {
    private(set) var privateKey: Data?
    private(set) var publicKey: Data
    private(set) var chainCode: Data
    private(set) var depth: UInt8
    private(set) var fingerprint: UInt32
    private(set) var childIndex: UInt32

    init(privateKey: Data?, publicKey: Data, chainCode: Data, depth: UInt8, fingerprint: UInt32, childIndex: UInt32) {
        self.privateKey = privateKey
        self.publicKey = publicKey
        self.chainCode = chainCode
        self.depth = depth
        self.fingerprint = fingerprint
        self.childIndex = childIndex
    }

    func derived(at childIndex: UInt32, hardened: Bool) -> _HDKey? {
        var data = Data()
        if hardened {
            data.append(0)
            guard let privateKey = self.privateKey else {
                return nil
            }
            data.append(privateKey)
        } else {
            data.append(publicKey)
        }
        var childIndex = CFSwapInt32HostToBig(hardened ? (0x80000000 as UInt32) | childIndex : childIndex)
        data.append(Data(bytes: &childIndex, count: MemoryLayout<UInt32>.size))
        var digest = HMAC.sign(data: data, algorithm: .sha512, key: self.chainCode)
        let derivedPrivateKey: [UInt8] = digest[0..<32].map { $0 }
        let derivedChainCode: [UInt8] = digest[32..<64].map { $0 }
        var result: Data
        if let privateKey = self.privateKey {
            guard let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN)) else {
                return nil
            }
            defer { secp256k1_context_destroy(ctx) }
            var privateKeyBytes = privateKey.map { $0 }
            var derivedPrivateKeyBytes = derivedPrivateKey.map { $0 }
            if secp256k1_ec_privkey_tweak_add(ctx, &privateKeyBytes, &derivedPrivateKeyBytes) == 0 {
                return nil
            }
            result = Data(privateKeyBytes)
        } else {
            guard let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_VERIFY)) else {
                return nil
            }
            defer { secp256k1_context_destroy(ctx) }
            let publicKeyBytes: [UInt8] = publicKey.map { $0 }
            var secpPubkey = secp256k1_pubkey()
            if secp256k1_ec_pubkey_parse(ctx, &secpPubkey, publicKeyBytes, publicKeyBytes.count) == 0 {
                return nil
            }
            if secp256k1_ec_pubkey_tweak_add(ctx, &secpPubkey, derivedPrivateKey) == 0 {
                return nil
            }
            var compressedPublicKeyBytes = [UInt8](repeating: 0, count: 33)
            var compressedPublicKeyBytesLen = 33
            if secp256k1_ec_pubkey_serialize(ctx, &compressedPublicKeyBytes, &compressedPublicKeyBytesLen, &secpPubkey, UInt32(SECP256K1_EC_COMPRESSED)) == 0 {
                return nil
            }
            result = Data(compressedPublicKeyBytes)
        }

        let fingerPrint: UInt32 = Crypto.sha256ripemd160(publicKey).to(type: UInt32.self)
        return _HDKey(privateKey: result, publicKey: result, chainCode: Data(derivedChainCode), depth: self.depth + 1, fingerprint: fingerPrint, childIndex: childIndex)
    }
}
