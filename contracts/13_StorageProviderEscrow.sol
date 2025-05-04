// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {IDatacapGateway} from "./interfaces/IDatacapGateway.sol";

contract StorageProviderEscrow is Ownable {
    address public datacapGatewayAddr;

    uint256 public id;

    uint256 public remainingDatacap;

    constructor(address initialOwner, address datacapGatewayAddress, uint256 newId) Ownable(initialOwner) {
        id = newId;
        datacapGatewayAddr = datacapGatewayAddress;
    }

    function hasDatacapGatewayAccess() external view returns (bool) {
        IDatacapGateway gateway = IDatacapGateway(datacapGatewayAddr);
        return gateway.hasAccess();
    }

    function setDatacap(uint256 amount) external onlyOwner {
        remainingDatacap = amount;
    }

    function addDatacap(uint256 amount) external onlyOwner {
        remainingDatacap += amount;
    }

    error InsufficientDatacap();

    event DatacapGranted(bytes indexed client, uint256 amount);

    // FIXME: SP access only
    function grantDatacap(bytes calldata clientFilecoinAddress, uint256 amount) external {
        if (remainingDatacap < amount) {
            revert InsufficientDatacap();
        }
        remainingDatacap -= amount;
        IDatacapGateway gateway = IDatacapGateway(datacapGatewayAddr);
        gateway.grantDatacap(clientFilecoinAddress, amount);
        emit DatacapGranted(clientFilecoinAddress, amount);
    }

    event DatacapGrantedMock(address indexed client, uint256 amount);

    // FIXME: SP access only
    function grantDatacapMock(address clientFilecoinAddress, uint256 amount) external {
         if (remainingDatacap < amount) {
            revert InsufficientDatacap();
        }
        remainingDatacap -= amount;
        IDatacapGateway gateway = IDatacapGateway(datacapGatewayAddr);
        gateway.grantDatacapMock(clientFilecoinAddress, amount);
    }

    // FIXME: ERC20 access
}