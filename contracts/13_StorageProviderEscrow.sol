// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {IDatacapGateway} from "../interfaces/IDatacapGateway.sol";

contract StorageProviderEscrow is Ownable {
    address public datacapGatewayAddr;

    uint256 public id;

    constructor(address initialOwner, address datacapGatewayAddress, uint256 newId) Ownable(initialOwner) {
        id = newId;
        datacapGatewayAddr = datacapGatewayAddress;
    }

    function hasDatacapGatewayAccess() external view returns (bool) {
        IDatacapGateway gateway = IDatacapGateway(datacapGatewayAddr);
        return gateway.hasAccess();
    }
}