// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import { IAxelarGateway } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol';
import { IAxelarGasService } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol';

import {IMockAllocator} from "./interfaces/IMockAllocator.sol";
import {IStorageProviderEscrowFactory} from "./interfaces/IStorageProviderEscrowFactory.sol";
import {IDatacapGateway} from "./interfaces/IDatacapGateway.sol";

contract DatacapGatewayAxelar is Ownable, IDatacapGateway {
    address public storageProviderEscrowFactoryAddr;

    address public axelarGatewayAddr;

    IAxelarGasService public immutable gasService;

    string public destChain;

    string public destAddr;

    constructor(
        address initialOwner,
        address axelarGateway,
        address axelarGasService,
        string memory destinationChain,
        string memory destinationAddress
    ) Ownable(initialOwner) {
        axelarGatewayAddr = axelarGateway;
        gasService = IAxelarGasService(axelarGasService);
        destChain = destinationChain;
        destAddr = destinationAddress;
    }

    receive() external payable {}

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

    function grantDatacap(bytes calldata clientFilecoinAddress, uint256 amount) external payable onlyEscrowContracts {
        // IMockAllocator allocator = IMockAllocator(mockAllocator);
        // allocator.addVerifiedClient(clientFilecoinAddress, amount);
    }

    function grantDatacapMock(address clientFilecoinAddress, uint256 amount) external payable onlyEscrowContracts {
        bytes memory payload = abi.encode(clientFilecoinAddress, amount);
        gasService.payNativeGasForContractCall{ value: msg.value }(
            address(this),
            destChain,
            destAddr,
            payload,
            msg.sender
        );
        IAxelarGateway gateway = IAxelarGateway(axelarGatewayAddr);
        gateway.callContract(destChain, destAddr, payload);

        // IMockAllocator allocator = IMockAllocator(mockAllocator);
        // allocator.addVerifiedClientMock(clientFilecoinAddress, amount);
    }
}