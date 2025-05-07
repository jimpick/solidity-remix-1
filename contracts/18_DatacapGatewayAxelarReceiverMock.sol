// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { AxelarExecutable } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol';
import { IERC20 } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IERC20.sol';

import {IMockAllocator} from "./interfaces/IMockAllocator.sol";

contract DatacapGatewayAxelarReceiverMock is AxelarExecutable {
    IMockAllocator mockAllocator;
    string public authorizedSourceChain;
    string public authorizedSourceAddress;

    address public clientFilecoinAddress;
    uint256 public amount;
    string public sourceChain;
    string public sourceAddress;

    event Executed(bytes32 commandId, string _from, address _clientFilecoinAddress, uint256 _amount);

    constructor(address axelarGateway, address mockAllocatorAddr) AxelarExecutable(axelarGateway) {
        mockAllocator = IMockAllocator(mockAllocatorAddr);
    }

    function setAuthorizedSourceChainAndAddress(string memory chain, string memory addr) public {
        authorizedSourceChain = chain;
        authorizedSourceAddress = addr;
    }

    error UnauthorizedSourceChain(string chain);
    error UnauthorizedSourceAddress(string addr);

    /**
     * @notice logic to be executed on dest chain
     * @dev this is triggered automatically by relayer
     * @param _sourceChain blockchain where tx is originating from
     * @param _sourceAddress address on src chain where tx is originating from
     * @param _payload encoded gmp message sent from src chain
     */
    function _execute(
        bytes32 commandId,
        string calldata _sourceChain,
        string calldata _sourceAddress,
        bytes calldata _payload
    ) internal override {
        (clientFilecoinAddress, amount) = abi.decode(_payload, (address, uint256));
        sourceChain = _sourceChain;
        sourceAddress = _sourceAddress;

        if (keccak256(abi.encodePacked(_sourceChain)) == keccak256(abi.encodePacked(authorizedSourceChain))) {
            revert UnauthorizedSourceChain(_sourceChain);
        }
        if (keccak256(abi.encodePacked(_sourceAddress)) == keccak256(abi.encodePacked(authorizedSourceAddress))) {
            revert UnauthorizedSourceChain(_sourceAddress);
        }

        emit Executed(commandId, sourceAddress, clientFilecoinAddress, amount);

        mockAllocator.addVerifiedClientMock(clientFilecoinAddress, amount);
    }
}