import XCTest
@testable import Bitcoin

class HDWalletTests: XCTestCase {
    var wallet: HDWallet!
    override func setUp() {
        let mnemonic: [String] = ["abandon", "abandon", "abandon", "abandon", "abandon", "abandon", "abandon", "abandon", "abandon", "abandon", "abandon", "about"]
        wallet = try! HDWallet(mnemonic: mnemonic,
                                        passphrase: "TREZOR",
                                        externalIndex: 0,
                                        internalIndex: 0,
                                        network: .mainnet)
    }

    func testInitFromMnemonic() {
        let mnemonic: [String] = ["abandon", "abandon", "abandon", "abandon", "abandon", "abandon", "abandon", "abandon", "abandon", "abandon", "abandon", "about"]
        let walletFromMnemonic: HDWallet = try! HDWallet(mnemonic: mnemonic,
                              passphrase: "TREZOR",
                              externalIndex: 0,
                              internalIndex: 0,
                              network: .mainnet)


        XCTAssertEqual(walletFromMnemonic.mnemonic,
                       ["abandon", "abandon", "abandon", "abandon", "abandon", "abandon", "abandon", "abandon", "abandon", "abandon", "abandon", "about"]
        )

        XCTAssertEqual(walletFromMnemonic.rootXPrivKey.description, "xprv9s21ZrQH143K3h3fDYiay8mocZ3afhfULfb5GX8kCBdno77K4HiA15Tg23wpbeF1pLfs1c5SPmYHrEpTuuRhxMwvKDwqdKiGJS9XFKzUsAF")
        XCTAssertEqual(walletFromMnemonic.rootXPubKey.description, "xpub661MyMwAqRbcGB88KaFbLGiYAat55APKhtWg4uYMkXAmfuSTbq2QYsn9sKJCj1YqZPafsboef4h4YbXXhNhPwMbkHTpkf3zLhx7HvFw1NDy")
        XCTAssertEqual(walletFromMnemonic.seed.hex, "c55257c360c07c72029aebc1b53c05ed0362ada38ead3e3e9efa3708e53495531f09a6987599d18264c1e1c92f2cf141630c7a3c4ab7c81b2f001698e7463b04")
    }

    func testInitFromSeed() {
        let seed: Data = Data(hex: "c55257c360c07c72029aebc1b53c05ed0362ada38ead3e3e9efa3708e53495531f09a6987599d18264c1e1c92f2cf141630c7a3c4ab7c81b2f001698e7463b04")!
        let walletFromSeed: HDWallet = HDWallet(seed: seed,
                                                    externalIndex: 0,
                                                    internalIndex: 0,
                                                    network: .mainnet)
        XCTAssertNil(walletFromSeed.mnemonic)
        XCTAssertEqual(walletFromSeed.rootXPrivKey.description, "xprv9s21ZrQH143K3h3fDYiay8mocZ3afhfULfb5GX8kCBdno77K4HiA15Tg23wpbeF1pLfs1c5SPmYHrEpTuuRhxMwvKDwqdKiGJS9XFKzUsAF")
        XCTAssertEqual(walletFromSeed.rootXPubKey.description, "xpub661MyMwAqRbcGB88KaFbLGiYAat55APKhtWg4uYMkXAmfuSTbq2QYsn9sKJCj1YqZPafsboef4h4YbXXhNhPwMbkHTpkf3zLhx7HvFw1NDy")
        XCTAssertEqual(walletFromSeed.seed.hex, "c55257c360c07c72029aebc1b53c05ed0362ada38ead3e3e9efa3708e53495531f09a6987599d18264c1e1c92f2cf141630c7a3c4ab7c81b2f001698e7463b04")
    }

    func testCreateWallet() {
        let created: HDWallet = HDWallet.create(passphrase: "BitcoinKit-Wallet", network: .mainnet)
        XCTAssertEqual(created.mnemonic?.count, 12)
        XCTAssertEqual(created.externalIndex, 0)
        XCTAssertEqual(created.internalIndex, 0)
        XCTAssertEqual(created.addresses.count, 2)

        let copied: HDWallet = try! HDWallet(mnemonic: created.mnemonic!,
                                        passphrase: "BitcoinKit-Wallet",
                                        externalIndex: created.externalIndex,
                                        internalIndex: created.internalIndex,
                                        network: created.network)
        XCTAssertEqual(created.mnemonic, copied.mnemonic)
        XCTAssertEqual(created.seed, copied.seed)
        XCTAssertEqual(created.rootXPrivKey.description, copied.rootXPrivKey.description)
        XCTAssertEqual(created.rootXPubKey.description, copied.rootXPubKey.description)
        XCTAssertEqual(created.addresses.map { $0.bech32 }, copied.addresses.map { $0.bech32 })
        XCTAssertEqual(created.address(index: 53, chain: .internal).bech32, copied.address(index: 53, chain: .internal).bech32)
        XCTAssertEqual(created.address(index: 152, chain: .external).bech32, copied.address(index: 152, chain: .external).bech32)
    }

    func testAddress() {
        XCTAssertEqual(wallet.externalIndex, 0)
        XCTAssertEqual(wallet.internalIndex, 0)
        XCTAssertEqual(wallet.addresses.count, 2)

        XCTAssertEqual(wallet.address.bech32,
                       "bc1q704q4wnnlkerjyht6g05dc2kehv7js5qyyrczp")
        XCTAssertEqual(wallet.changeAddress.bech32,
                       "bc1qurf2yd66darag329pcnmfrmr880dkek5lx2s69")
        XCTAssertEqual(wallet.addresses.map { $0.bech32 }, [
            "bc1q704q4wnnlkerjyht6g05dc2kehv7js5qyyrczp",
            "bc1qurf2yd66darag329pcnmfrmr880dkek5lx2s69"
            ])

        XCTAssertEqual(wallet.address(index: 3, chain: .internal).bech32,
                       "bc1q90vp636la7k7mv4dy89xdxxp4pl2tprzvkh9wm")
        XCTAssertEqual(wallet.address(index: 5, chain: .external).bech32,
                       "bc1qn259fcnj8yx5lyn4tlp3sxt4y8w768cx43nny6")
    }

    func testIncrementExternalIndex() {
        // Increment Receive Key
        wallet.incrementExternalIndex(by: 1)
        XCTAssertEqual(wallet.externalIndex, 1)
        XCTAssertEqual(wallet.internalIndex, 0)
        XCTAssertEqual(wallet.address.bech32,
                       "bc1qa0334608z2ccawww3lvgk8fs0dp5jy7aazeuhq")
        XCTAssertEqual(wallet.addresses.count, 3)
        XCTAssertEqual(wallet.addresses.map { $0.bech32 },
                       ["bc1q704q4wnnlkerjyht6g05dc2kehv7js5qyyrczp",
                        "bc1qa0334608z2ccawww3lvgk8fs0dp5jy7aazeuhq",
                        "bc1qurf2yd66darag329pcnmfrmr880dkek5lx2s69"]
        )
    }

    func testIncrementInternalIndex() {
        wallet.incrementInternalIndex(by: 1)
        XCTAssertEqual(wallet.externalIndex, 0)
        XCTAssertEqual(wallet.internalIndex, 1)
        XCTAssertEqual(wallet.changeAddress.bech32, "bc1q53pel38yn200w3v256dqe48rhjmwa5mypgq609")
        XCTAssertEqual(wallet.addresses.count, 3)
        XCTAssertEqual(wallet.addresses.map { $0.bech32 },
                       ["bc1q704q4wnnlkerjyht6g05dc2kehv7js5qyyrczp",
                        "bc1qurf2yd66darag329pcnmfrmr880dkek5lx2s69",
                        "bc1q53pel38yn200w3v256dqe48rhjmwa5mypgq609"]
        )
    }
}
