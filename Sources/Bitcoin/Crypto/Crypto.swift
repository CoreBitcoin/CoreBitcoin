import Foundation
import CommonCrypto
import secp256k1

public struct Crypto {

    public enum CryptoError: Error {
        case signFailed
        case notEnoughSpace
        case signatureParseFailed
        case publicKeyParseFailed
    }

    public static func sha1(_ data: Data) -> Data {
        return digest(data, function: Digest.sha1)
    }

    public static func sha256(_ data: Data) -> Data {
        return digest(data, function: Digest.sha256)
    }

    public static func sha256sha256(_ data: Data) -> Data {
        return sha256(sha256(data))
    }

    public static func ripemd160(_ data: Data) -> Data {
        return RIPEMD160.hash(message: data)
    }

    public static func sha256ripemd160(_ data: Data) -> Data {
        return RIPEMD160.hash(message: sha256(data))
    }

    public static func sha512(_ data: Data) -> Data {
        return digest(data, function: Digest.sha512)
    }

    private static func digest(_ data: Data, function: ((UnsafeRawBufferPointer, UInt32) -> [UInt8])) -> Data {
        var hash: [UInt8] = []
        data.withUnsafeBytes { hash = function($0, UInt32(data.count)) }
        return Data(bytes: hash, count: hash.count)
    }

    public static func hmac(data: Data, key: Data, algorithm: HMAC.Algorithm) -> Data {
        return HMAC.sign(data: data, algorithm: algorithm, key: key)
    }

    public static func sign(_ data: Data, privateKey: PrivateKey) throws -> Data {
        precondition(data.count > 0, "Data must be non-zero size")
        precondition(privateKey.data.count > 0, "PrivateKey must be non-zero size")

        let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN))!
        defer { secp256k1_context_destroy(ctx) }

        let signature = UnsafeMutablePointer<secp256k1_ecdsa_signature>.allocate(capacity: 1)
        let status = data.withUnsafeBytes { ptr in
            privateKey.data.withUnsafeBytes { secp256k1_ecdsa_sign(ctx, signature, ptr.baseAddress!.assumingMemoryBound(to: UInt8.self), $0.baseAddress!.assumingMemoryBound(to: UInt8.self), nil, nil) }
        }
        guard status == 1 else { throw CryptoError.signFailed }

        let normalizedsig = UnsafeMutablePointer<secp256k1_ecdsa_signature>.allocate(capacity: 1)
        secp256k1_ecdsa_signature_normalize(ctx, normalizedsig, signature)

        var length: size_t = 128
        var der = Data(count: length)
        guard der.withUnsafeMutableBytes({ return secp256k1_ecdsa_signature_serialize_der(ctx, $0.baseAddress!.assumingMemoryBound(to: UInt8.self), &length, normalizedsig) }) == 1 else { throw CryptoError.notEnoughSpace }
        der.count = length

        return der
    }

    public static func verifySignature(_ signature: Data, message: Data, publicKey: Data) throws -> Bool {
        let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_VERIFY))!
        defer { secp256k1_context_destroy(ctx) }

        let signaturePointer = UnsafeMutablePointer<secp256k1_ecdsa_signature>.allocate(capacity: 1)
        defer { signaturePointer.deallocate() }
        guard signature.withUnsafeBytes({ secp256k1_ecdsa_signature_parse_der(ctx, signaturePointer, $0, signature.count) }) == 1 else {
            throw CryptoError.signatureParseFailed
        }

        let pubkeyPointer = UnsafeMutablePointer<secp256k1_pubkey>.allocate(capacity: 1)
        defer { pubkeyPointer.deallocate() }
        guard publicKey.withUnsafeBytes({ secp256k1_ec_pubkey_parse(ctx, pubkeyPointer, $0, publicKey.count) }) == 1 else {
            throw CryptoError.publicKeyParseFailed
        }

        guard message.withUnsafeBytes ({ secp256k1_ecdsa_verify(ctx, signaturePointer, $0, pubkeyPointer) }) == 1 else {
            return false
        }

        return true
    }

//    public static func verifySigData(for tx: Transaction, inputIndex: Int, utxo: TransactionOutput, sigData: Data, pubKeyData: Data) throws -> Bool {
//        // Hash type is one byte tacked on to the end of the signature. So the signature shouldn't be empty.
//        guard !sigData.isEmpty else {
//            throw ScriptMachineError.error("SigData is empty.")
//        }
//        // Extract hash type from the last byte of the signature.
//        let hashType = SighashType(sigData.last!)
//        // Strip that last byte to have a pure signature.
//        let signature = sigData.dropLast()
//
//        let sighash: Data = tx.signatureHash(for: utxo, inputIndex: inputIndex, hashType: hashType)
//
//        return try Crypto.verifySignature(signature, message: sighash, publicKey: pubKeyData)
//    }

    public static func verifySigData(for tx: Transaction, inputIndex: Int, utxo: TransactionOutput, sigData: Data, pubKeyData: Data) throws -> Bool {
        // Hash type is one byte tacked on to the end of the signature. So the signature shouldn't be empty.
        guard !sigData.isEmpty else {
            throw ScriptMachineError.error("SigData is empty.")
        }
        // Extract hash type from the last byte of the signature.
        let helper: SignatureHashHelper
        if let hashType = BTCSighashType(rawValue: sigData.last!) {
            helper = BTCSignatureHashHelper(hashType: hashType)
        } else {
            throw ScriptMachineError.error("Unknown sig hash type")
        }
        // Strip that last byte to have a pure signature.
        let sighash: Data = helper.createSignatureHash(of: tx, for: utxo, inputIndex: inputIndex)
        let signature: Data = sigData.dropLast()

        return try Crypto.verifySignature(signature, message: sighash, publicKey: pubKeyData)
    }
}
