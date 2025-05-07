// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/**
 * @title Interface for Allocator contract
 * @notice Definition of core functions and events of the Allocator contract
 */
interface IStorageProviderEscrowFactory {
    error DatacapGatewayUnset();

    function datacapGateway() external returns (address);

    function setDatacapGateway(address datacapGatewayAddress) external;

    function createStorageProviderEscrow() external;

    function getEscrowById(uint256 id) external view returns (address);
 
    function getAllEscrows() external view returns (address[] memory);

    function isEscrow(address escrowContract) external view returns (bool);
}
