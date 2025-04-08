// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

module test_nft::nft;

use std::string;
use sui::{event, url::{Self, Url}};

/// An example NFT that can be minted by anybody
public struct TestNFT has key, store {
    id: UID,
    /// Name for the token
    name: string::String,
    /// Description of the token
    description: string::String,
    /// URL for the token
    url: Url,
    // TODO: allow custom attributes
    is_soulbound: bool
}

// ===== Events =====

public struct NFTMinted has copy, drop {
    // The Object ID of the NFT
    object_id: ID,
    // The creator of the NFT
    creator: address,
    // The name of the NFT
    name: string::String,
    // soulbound
    is_soulbound: bool
}

// === Error codes ===

/// Attempted to transfer that soulbound nft
const ETransfer: u64 = 0;


// ===== Public view functions =====

/// Get the NFT's `name`
public fun name(nft: &TestNFT): &string::String {
    &nft.name
}

/// Get the NFT's `description`
public fun description(nft: &TestNFT): &string::String {
    &nft.description
}

/// Get the NFT's `url`
public fun url(nft: &TestNFT): &Url {
    &nft.url
}

/// Get the NFT's `soulbound`
public fun soulbound(nft: &TestNFT): &bool {
    &nft.is_soulbound
}


// ===== Entrypoints =====

#[allow(lint(self_transfer))]
/// Create a new devnet_nft
public fun mint_to_sender(
    name: vector<u8>,
    description: vector<u8>,
    url: vector<u8>,
    recipient: address,
    ctx: &mut TxContext,
) {
    let sender = ctx.sender();
    let nft = TestNFT {
        id: object::new(ctx),
        name: string::utf8(name),
        description: string::utf8(description),
        url: url::new_unsafe_from_bytes(url),
        is_soulbound: false
    };

    event::emit(NFTMinted {
        object_id: object::id(&nft),
        creator: sender,
        name: nft.name,
        is_soulbound: false
    });

    transfer::public_transfer(nft, recipient);
}

/// Create a new devnet_nft
public fun airdrop_to_sender(
    name: vector<u8>,
    description: vector<u8>,
    url: vector<u8>,
    recipient: address,
    ctx: &mut TxContext,
) {
    let sender = ctx.sender();
    let nft = TestNFT {
        id: object::new(ctx),
        name: string::utf8(name),
        description: string::utf8(description),
        url: url::new_unsafe_from_bytes(url),
        is_soulbound: true
    };

    event::emit(NFTMinted {
        object_id: object::id(&nft),
        creator: sender,
        name: nft.name,
        is_soulbound: true
    });

    transfer::public_transfer(nft, recipient);
}

/// Transfer `nft` to `recipient`
public fun transfer(nft: TestNFT, recipient: address, _: &mut TxContext) {
    assert!(nft.is_soulbound == false, ETransfer);
    
    transfer::public_transfer(nft, recipient)
}

/// Permanently delete `nft`
public fun burn(nft: TestNFT, _: &mut TxContext) {
    let TestNFT { id, name: _, description: _, url: _, is_soulbound: _ } = nft;
    id.delete()
}


#[test_only]
use sui::{test_scenario};

#[test]
fun test_mint_to_sender() {
    let mut scenario_val = test_scenario::begin(@0x0);

    let alice = @0xA;
    let bob = @0xB;

    let name = b"nft";
    let description = b"This is nft description";
    let url = b"https://nft.0.1/821.git";

    mint_to_sender(name, description, url, alice, scenario_val.ctx());
}

#[test]
fun test_airdrop_to_sender() {
    let mut scenario_val = test_scenario::begin(@0x0);

    let recipient = @0xA;

    let name=b"nft";
    let description = b"description";
    let url = b"https://nft.0.1/2832.gif";

    airdrop_to_sender(name, description, url, recipient, scenario_val.ctx());
}