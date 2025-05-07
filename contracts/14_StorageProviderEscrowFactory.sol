// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {EnumerableMap} from "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";
import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

import {IStorageProviderEscrowFactory} from "./interfaces/IStorageProviderEscrowFactory.sol";

import {StorageProviderEscrow} from "./13_StorageProviderEscrow.sol";

contract StorageProviderEscrowFactory is Ownable, IStorageProviderEscrowFactory {
    using EnumerableMap for EnumerableMap.UintToAddressMap;
    using EnumerableSet for EnumerableSet.AddressSet;

    address public usdcAddr;

    address private datacapGatewayAddr;

    EnumerableSet.AddressSet private _escrows;
    EnumerableMap.UintToAddressMap private _escrowsById;
 
    uint256 public nextId;

    constructor(address initialOwner, address usdcAddress) Ownable(initialOwner) {
        usdcAddr = usdcAddress;
    }

    function setDatacapGateway(address datacapGatewayAddress) external onlyOwner {
        datacapGatewayAddr = datacapGatewayAddress;
    }

    function datacapGateway() external view returns (address) {
        return datacapGatewayAddr;    
    }

    event StorageProviderEscrowCreated(address indexed escrow);

    function createStorageProviderEscrow() external onlyOwner {
        if (datacapGatewayAddr == address(0)) {
            revert DatacapGatewayUnset();
        }
        StorageProviderEscrow spEscrow = new StorageProviderEscrow(msg.sender, usdcAddr, nextId);
        address spEscrowAddr = address(spEscrow);
        _escrows.add(spEscrowAddr);
        _escrowsById.set(nextId, spEscrowAddr);
        emit StorageProviderEscrowCreated(spEscrowAddr);
        nextId++;
    }

    function getEscrowById(uint256 id) external view returns (address) {
        return _escrowsById.get(id);
    }

    function getAllEscrows() external view returns (address[] memory) {
        return _escrows.values();
    }

    function isEscrow(address escrowContract) external view returns (bool) {
        return _escrows.contains(escrowContract);
    }
}