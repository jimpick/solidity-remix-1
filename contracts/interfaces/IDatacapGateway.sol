// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IDatacapGateway {
    error StorageProviderEscrowFactoryUnset();

    error UnauthorizedAccount(address account);

    function setStorageProviderEscrowFactory(address storageProviderEscrowFactoryAddress) external;

    function hasAccess() external view returns (bool);
 
    function grantDatacap(bytes calldata clientFilecoinAddress, uint256 amount) external payable;
 
    function grantDatacapMock(address clientFilecoinAddress, uint256 amount) external payable;
}
