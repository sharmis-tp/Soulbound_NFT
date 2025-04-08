// /*
// #[test_only]
// module my_first_package::my_first_package_tests;
// // uncomment this line to import the module
// // use my_first_package::my_first_package;

// const ENotImplemented: u64 = 0;

// #[test]
// fun test_my_first_package() {
//     // pass
// }

// #[test, expected_failure(abort_code = ::my_first_package::my_first_package_tests::ENotImplemented)]
// fun test_my_first_package_fail() {
//     abort ENotImplemented
// }
// */

// #[test_only]
// module test_nft::nft_tests;

// use test_nft::nft;
// use std::{string};
// use sui::{test_scenario};

// #[test]
// fun test_mint_to_sender() {
//     let mut scenario_val = test_scenario::begin(@0x0);

//     let alice = @0xA;
//     let bob = @0xB;

//     let name = b"nft";
//     let description = b"This is nft description";
//     let url = b"https://nft.0.1/821.git";

//     nft::mint_to_sender(name, description, url, alice, scenario_val.ctx());
// }

// #[test]
// fun test_airdrop_to_sender() {
//     let mut scenario_val = test_scenario::begin(@0x0);

//     let recipient = @0xA;

//     let name=b"nft";
//     let description = b"description";
//     let url = b"https://nft.0.1/2832.gif";

//     nft::airdrop_to_sender(name, description, url, recipient, scenario_val.ctx());
// }