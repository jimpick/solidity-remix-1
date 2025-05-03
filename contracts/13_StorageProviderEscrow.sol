// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract StorageProviderEscrow is Ownable {

    uint256 public number;

    constructor(address initialOwner, uint256 num) Ownable(initialOwner) {
        number = num;
    }

}