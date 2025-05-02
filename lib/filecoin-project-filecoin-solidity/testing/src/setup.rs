use fvm::executor::{ApplyKind, ApplyRet, Executor};
use cid::Cid;
use fvm::machine::Manifest;
use fvm_ipld_blockstore::MemoryBlockstore;
use fvm_integration_tests::tester::Tester;
use fvm_shared::state::StateTreeVersion;
use fvm_shared::version::NetworkVersion;
use fvm_integration_tests::bundle;
use fvm_ipld_encoding::CborStore;
use fvm_integration_tests::dummy::DummyExterns;
use fvm_ipld_encoding::tuple::*;

pub fn setup_tester() -> (Tester<MemoryBlockstore, DummyExterns>, Manifest) {
    let bs = MemoryBlockstore::default();
    let bundle_root = bundle::import_bundle(&bs, actors_v12::BUNDLE_CAR).unwrap();

    let (manifest_version, manifest_data_cid): (u32, Cid) =
        bs.get_cbor(&bundle_root).unwrap().unwrap();
    let manifest = Manifest::load(&bs, &manifest_data_cid, manifest_version).unwrap();

    let tester =
        Tester::new(NetworkVersion::V21, StateTreeVersion::V5, bundle_root, bs).unwrap();

    return (tester, manifest)
}

pub fn load_evm(path: &str) -> Vec<u8> {
    let wasm_path = std::env::current_dir()
        .unwrap()
        .join(path)
        .canonicalize()
        .unwrap();
    let evm_hex = std::fs::read(wasm_path).expect("Unable to read file");

    hex::decode(evm_hex).unwrap()
}