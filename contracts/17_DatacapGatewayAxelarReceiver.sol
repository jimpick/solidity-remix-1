// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { AxelarExecutable } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol';
import { IERC20 } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IERC20.sol';

contract DatacapGatewayAxelarReceiver is AxelarExecutable {
    string public message;
    string public sourceChain;
    string public sourceAddress;

    event Executed(bytes32 commandId, string _from, string _message);

    /**
     * @param _gateway address of axl gateway on deployed chain
     */
    constructor(address _gateway) AxelarExecutable(_gateway) {
    }

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
        (message) = abi.decode(_payload, (string));
        sourceChain = _sourceChain;
        sourceAddress = _sourceAddress;

        emit Executed(commandId, sourceAddress, message);
    }
}