// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {IMockAllocator} from "./interfaces/IMockAllocator.sol";
import {IStorageProviderEscrowFactory} from "./interfaces/IStorageProviderEscrowFactory.sol";
import {IDatacapGateway} from "./interfaces/IDatacapGateway.sol";

contract DatacapGatewayDirect is Ownable, IDatacapGateway {
    address public mockAllocator;

    address public storageProviderEscrowFactoryAddr;

    constructor(address initialOwner, address _mockAllocator) Ownable(initialOwner) {
        mockAllocator = _mockAllocator;
    }

    function setStorageProviderEscrowFactory(address storageProviderEscrowFactoryAddress) external onlyOwner {
        storageProviderEscrowFactoryAddr = storageProviderEscrowFactoryAddress;
    }

    modifier onlyEscrowContracts() {
        if (storageProviderEscrowFactoryAddr == address(0)) {
            revert StorageProviderEscrowFactoryUnset();
        }

        IStorageProviderEscrowFactory factory = IStorageProviderEscrowFactory(storageProviderEscrowFactoryAddr);
        if (!factory.isEscrow(msg.sender)) {
            revert UnauthorizedAccount(msg.sender);
        }
        _;
    }

    function hasAccess() external view onlyEscrowContracts returns (bool) {
        return true;
    }

    function grantDatacap(bytes calldata clientFilecoinAddress, uint256 amount) external onlyEscrowContracts {
        IMockAllocator allocator = IMockAllocator(mockAllocator);
        allocator.addVerifiedClient(clientFilecoinAddress, amount);
    }

    function grantDatacapMock(address clientFilecoinAddress, uint256 amount) external onlyEscrowContracts {
        IMockAllocator allocator = IMockAllocator(mockAllocator);
        allocator.addVerifiedClientMock(clientFilecoinAddress, amount);
    }
}