import 'package:flutter/foundation.dart';
import 'package:phantom_connect/phantom_connect.dart';
import 'package:solana/encoder.dart' as encoder;
// ignore: depend_on_referenced_packages
import 'package:solana/dto.dart';
// ignore: depend_on_referenced_packages
import 'package:solana/metaplex.dart';
// ignore: depend_on_referenced_packages
import 'package:solana/solana.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/app_strings.dart';
import '../../config/solana_config.dart';
import '../../domain/metadata_NFT.dart';

class PhantomWalletSource {
  int totalSupply = 1;

  final SolanaClient client = createTestSolanaClient(useLocal: false);

  //Connecting to phantom wallet
  Future<void> connectWallet(PhantomConnect phantomConnectInstance) async {
    Uri launchUri = phantomConnectInstance.generateConnectUri(
        cluster: "devnet", redirect: '/${AppStrings.connectedLink}');
    await launchUrl(
      launchUri,
      mode: LaunchMode.externalApplication,
    );
  }

  //Creating metadata account
  Future<void> metadataAccount(MetadataNFT nftData,
      PhantomConnect phantomConnect, String tokenPublicKey) async {
    //Creating metadata data
    final dataMetadata = CreateMetadataAccountV3Data(
      name: nftData.name,
      symbol: nftData.symbol,
      uri: nftData.dataUri,
      sellerFeeBasisPoints: 500,
      isMutable: true,
      colectionDetails: false,
      creators: [
        MetadataCreator(
          address: Ed25519HDPublicKey.fromBase58(phantomConnect.userPublicKey),
          verified: true,
          share: 100,
        ),
      ],
    );

    //Creating Metadata Account
    final instruction = await createMetadataAccountV3(
      mint: Ed25519HDPublicKey.fromBase58(tokenPublicKey),
      mintAuthority:
          Ed25519HDPublicKey.fromBase58(phantomConnect.userPublicKey),
      payer: Ed25519HDPublicKey.fromBase58(phantomConnect.userPublicKey),
      updateAuthority:
          Ed25519HDPublicKey.fromBase58(phantomConnect.userPublicKey),
      data: dataMetadata,
    );

    await _signingTransaction(instruction, phantomConnect);
  }

  //Creating token
  Future<String> createToken(PhantomConnect phantomConnect) async {
    //Generating random key pair
    final mint = await Ed25519HDKeyPair.random();

    //Getting rent space
    const space = TokenProgram.neededMintAccountSpace;
    final rent = await client.rpcClient.getMinimumBalanceForRentExemption(
      space,
      commitment: Commitment.confirmed,
    );

    //Creating token instruction
    final instructionMint = TokenInstruction.createAccountAndInitializeMint(
      mint: mint.publicKey,
      mintAuthority:
          Ed25519HDPublicKey.fromBase58(phantomConnect.userPublicKey),
      freezeAuthority:
          Ed25519HDPublicKey.fromBase58(phantomConnect.userPublicKey),
      rent: rent,
      space: space,
      decimals: 0,
    );

    //Constructing a message from the instruction
    final message = Message(instructions: instructionMint);

    //Getting recent block hash data
    final blockhash = await client.rpcClient
        .getRecentBlockhash()
        .then((value) => value.blockhash);
    final compiled = message.compile(recentBlockhash: blockhash);

    //Creating a transaction
    final transaction =
        encoder.SignedTx(messageBytes: compiled.data, signatures: [
      Signature(
        List.filled(64, 0),
        publicKey: Ed25519HDPublicKey.fromBase58(phantomConnect.userPublicKey),
      ),
      await mint.sign(compiled.data),
    ]).encode();

    //Generating transaction uri to be used in Phantom wallet
    var launchUri = phantomConnect.generateSignAndSendTransactionUri(
      transaction: transaction,
      redirect: '/${AppStrings.signAndSendTransactionLink}',
    );

    //Launching the Phantom Application
    await launchUrl(
      launchUri,
      mode: LaunchMode.externalApplication,
    );

    return mint.publicKey.toBase58();
  }

  //Creating associated account
  Future<void> associatedAccount(
      PhantomConnect phantomConnect, String tokenPublicKey) async {
    //Getting user public key
    final ownerKey =
        Ed25519HDPublicKey.fromBase58(phantomConnect.userPublicKey);

    //Deriving token address from user public key.
    final derivedAddress = await findAssociatedTokenAddress(
      owner: ownerKey,
      mint: Ed25519HDPublicKey.fromBase58(tokenPublicKey),
    );

    //Creating an instruction for the associated token account program.
    final instruction = AssociatedTokenAccountInstruction.createAccount(
      mint: Ed25519HDPublicKey.fromBase58(tokenPublicKey),
      address: derivedAddress,
      owner: ownerKey,
      funder: ownerKey,
    );

    await _signingTransaction(instruction, phantomConnect);
  }

  //Creating NFT
  createNFT(PhantomConnect phantomConnect, String tokenPublicKey) async {
    //Getting all token accounts owned by the user's public key
    var ownerTokenAccounts = await client.rpcClient.getTokenAccountsByOwner(
      phantomConnect.userPublicKey,
      TokenAccountsFilter.byMint(tokenPublicKey),
      encoding: Encoding.jsonParsed,
      commitment: Commitment.confirmed,
    );

    //Creating minting instructions
    final instruction = TokenInstruction.mintTo(
      mint: Ed25519HDPublicKey.fromBase58(tokenPublicKey),
      destination:
          Ed25519HDPublicKey.fromBase58(ownerTokenAccounts.first.pubkey),
      authority: Ed25519HDPublicKey.fromBase58(phantomConnect.userPublicKey),
      amount: totalSupply,
    );

    await _signingTransaction(instruction, phantomConnect);
  }

  //Removing Minting authority
  removeAuthority(PhantomConnect phantomConnect, String tokenPublicKey) async {
    //Removing authority instruction
    var instruction = TokenInstruction.setAuthority(
      mintOrAccount: Ed25519HDPublicKey.fromBase58(tokenPublicKey),
      currentAuthority:
          Ed25519HDPublicKey.fromBase58(phantomConnect.userPublicKey),
      authorityType: AuthorityType.mintTokens,
      newAuthority: null,
    );

    await _signingTransaction(instruction, phantomConnect);
  }

  Future<void> _signingTransaction(
      encoder.Instruction instruction, PhantomConnect phantomConnect) async {
    final message = Message.only(instruction);

    final blockhash = await client.rpcClient
        .getRecentBlockhash()
        .then((value) => value.blockhash);
    final compiled = message.compile(recentBlockhash: blockhash);

    final transaction =
        encoder.SignedTx(messageBytes: compiled.data, signatures: [
      Signature(
        List.filled(64, 0),
        publicKey: Ed25519HDPublicKey.fromBase58(phantomConnect.userPublicKey),
      ),
    ]).encode();

    var launchUri = phantomConnect.generateSignAndSendTransactionUri(
        transaction: transaction,
        redirect: '/${AppStrings.signAndSendTransactionLink}');
    await launchUrl(
      launchUri,
      mode: LaunchMode.externalApplication,
    );
  }
}
