// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IMockAllocator} from "./interfaces/IMockAllocator.sol";
import {VerifRegAPI} from "../lib/filecoin-solidity/contracts/v0.8/VerifRegAPI.sol";
import {VerifRegTypes} from "../lib/filecoin-solidity/contracts/v0.8/types/VerifRegTypes.sol";
import {CommonTypes} from "../lib/filecoin-solidity/contracts/v0.8/types/CommonTypes.sol";
import {FilAddresses} from "../lib/filecoin-solidity/contracts/v0.8/utils/FilAddresses.sol";
import {PrecompilesAPI} from "../lib/filecoin-solidity/contracts/v0.8/PrecompilesAPI.sol";
import {FilAddressIdConverter} from "../lib/filecoin-project-filecoin-solidity/contracts/v0.8/utils/FilAddressIdConverter.sol";
import {EnumerableMap} from "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title MockAllocator
 * @notice This contract functions as a middle-man for Allocators. It's made a
 * Verifier (a.k.a. Notary) on Filecoin chain and granted DataCap that can then
 * be granted to Clients. Granting to clients can be done by Allocators that get
 * allowance on the contract, assigned by contract owner.
 * @dev Contract is upgradeable via UUPS by contract owner.
 */
contract MockAllocator is Ownable, IMockAllocator {
    using EnumerableMap for EnumerableMap.AddressToUintMap;

    /**
     * @notice Enumerable mapping from allocator addresses to their current
     * allowance
     */
    EnumerableMap.AddressToUintMap private _allocators;

    // Address of Mock Datacap contract
    address public mockDatacap;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor(address initialOwner, address _mockDatacapAddress) Ownable(initialOwner) {
        mockDatacap = _mockDatacapAddress;
    }

    /**
     * @notice Get allowance of an allocator
     * @param allocator Allocator to get allowance for
     * @return allowance_ Allocator's allowance
     */
    function allowance(address allocator) public view returns (uint256 allowance_) {
        (, allowance_) = _allocators.tryGet(allocator);
    }

    /**
     * @notice Add allowance to Allocator
     * @param allocator Allocator that will receive allowance
     * @param amount Amount of allowance to add
     * @dev Emits AllowanceChanged event
     * @dev Reverts if not called by contract owner
     * @dev Reverts if trying to add 0 allowance
     */
    function addAllowance(address allocator, uint256 amount) external onlyOwner {
        if (amount == 0) revert AmountEqualZero();
        uint256 allowanceBefore = allowance(allocator);
        _allocators.set(allocator, allowanceBefore + amount);
        emit AllowanceChanged(allocator, allowanceBefore, allowance(allocator));
    }

    /**
     * @notice Set allowance of an Allocator. Can be used to remove allowance.
     * @param allocator Allocator
     * @param amount Amount of allowance to set
     * @dev Emits AllowanceChanged event
     * @dev Reverts if not called by contract owner
     * @dev Reverts if setting to 0 when allocator already has 0 allowance
     */
    function setAllowance(address allocator, uint256 amount) external onlyOwner {
        uint256 allowanceBefore = allowance(allocator);
        if (allowanceBefore == 0 && amount == 0) {
            revert AlreadyZero();
        } else if (allowanceBefore > 0 && amount > 0) {
            revert AlreadyHasAllowance();
        } else if (allowanceBefore == 0 && amount > 0) {
            _allocators.set(allocator, amount);
        } else if (allowanceBefore > 0 && amount == 0) {
            _allocators.remove(allocator);
        }
        emit AllowanceChanged(allocator, allowanceBefore, allowance(allocator));
    }

    /**
     * @notice Grant allowance to a client.
     * @param clientAddress Filecoin address of the client
     * @param amount Amount of datacap to grant
     * @dev Emits DatacapAllocated event
     * @dev Reverts with InsufficientAllowance if caller doesn't have sufficient allowance
     * @custom:oz-upgrades-unsafe-allow-reachable delegatecall
     */
    function addVerifiedClient(bytes calldata clientAddress, uint256 amount) external {
        if (amount == 0) revert AmountEqualZero();
        uint256 allocatorBalance = allowance(msg.sender);
        if (allocatorBalance < amount) revert InsufficientAllowance();
        if (allocatorBalance - amount == 0) {
            _allocators.remove(msg.sender);
        } else {
            _allocators.set(msg.sender, allocatorBalance - amount);
        }
        emit DatacapAllocated(msg.sender, clientAddress, amount);
        /*
        VerifRegTypes.AddVerifiedClientParams memory params = VerifRegTypes.AddVerifiedClientParams({
            addr: FilAddresses.fromBytes(clientAddress),
            allowance: CommonTypes.BigInt(abi.encodePacked(amount), false)
        });
        VerifRegAPI.addVerifiedClient(params);
        */

        // Use mock datacap instead of system actor for demo
        CommonTypes.FilAddress memory filecoinAddr = FilAddresses.fromBytes(clientAddress);
        uint64 actorID = PrecompilesAPI.resolveAddress(filecoinAddr);
        address addr = FilAddressIdConverter.toAddress(actorID);
        IERC20 mockDatacapContract = IERC20(mockDatacap);
        mockDatacapContract.transfer(addr, amount);
    }

   /**
     * @notice Grant allowance to a client.
     * @param clientAddress Filecoin address of the client
     * @param amount Amount of datacap to grant
     * @dev Emits DatacapAllocated event
     * @dev Reverts with InsufficientAllowance if caller doesn't have sufficient allowance
     * @custom:oz-upgrades-unsafe-allow-reachable delegatecall
     */
    function addVerifiedClientMock(address clientAddress, uint256 amount) external {
        if (amount == 0) revert AmountEqualZero();
        uint256 allocatorBalance = allowance(msg.sender);
        if (allocatorBalance < amount) revert InsufficientAllowance();
        if (allocatorBalance - amount == 0) {
            _allocators.remove(msg.sender);
        } else {
            _allocators.set(msg.sender, allocatorBalance - amount);
        }
        // emit DatacapAllocated(msg.sender, clientAddress, amount);
        /*
        VerifRegTypes.AddVerifiedClientParams memory params = VerifRegTypes.AddVerifiedClientParams({
            addr: FilAddresses.fromBytes(clientAddress),
            allowance: CommonTypes.BigInt(abi.encodePacked(amount), false)
        });
        VerifRegAPI.addVerifiedClient(params);
        */

        // Use mock datacap instead of system actor for demo
        /*
        CommonTypes.FilAddress memory filecoinAddr = FilAddresses.fromBytes(clientAddress);
        uint64 actorID = PrecompilesAPI.resolveAddress(filecoinAddr);
        address addr = FilAddressIdConverter.toAddress(actorID);
        */
        IERC20 mockDatacapContract = IERC20(mockDatacap);
        mockDatacapContract.transfer(clientAddress, amount);
    }

    /**
     * @notice Get all allocators with non-zero allowance
     * @return allocators List of allocators with non-zero allowance
     */
    function getAllocators() external view returns (address[] memory allocators) {
        return _allocators.keys();
    }

    // Helpful utilities 

    function getAddrBytesFromActorID(uint64 actorID) public pure returns (bytes memory){
        CommonTypes.FilAddress memory addr = FilAddresses.fromActorID(actorID);
        return addr.data;
    }

    function getEthAddrFromActorID(uint64 actorID) public view returns (address){
        return FilAddressIdConverter.toAddress(actorID);
    }

    function getEthAddrFromBytes(bytes calldata clientAddress) public view returns (address){
        CommonTypes.FilAddress memory filecoinAddr = FilAddresses.fromBytes(clientAddress);
        uint64 actorID = PrecompilesAPI.resolveAddress(filecoinAddr);
        return FilAddressIdConverter.toAddress(actorID);
    }
}
