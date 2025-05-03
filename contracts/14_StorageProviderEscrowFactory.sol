// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.0;

import {EnumerableMap} from "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";
import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

import {StorageProviderEscrow} from "./13_StorageProviderEscrow.sol";

contract StorageProviderEscrowFactory {
    using EnumerableMap for EnumerableMap.UintToAddressMap;
    using EnumerableSet for EnumerableSet.AddressSet;

    EnumerableSet.AddressSet private _escrows;
    EnumerableMap.UintToAddressMap private _escrowsById;
 
    uint256 public nextId;

    function createStorageProviderEscrow() public {
        StorageProviderEscrow spEscrow = new StorageProviderEscrow(msg.sender, nextId);
        _escrows.add(address(spEscrow));
        _escrowsById.set(nextId, address(spEscrow));
        nextId++;
    }

    function getEscrowById(uint256 id) public view returns (address) {
        return _escrowsById.get(id);
    }

    function getAllEscrows() public view returns (address[] memory) {
        return _escrows.values();
    }
}