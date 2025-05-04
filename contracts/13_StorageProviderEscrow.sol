// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {IDatacapGateway} from "./interfaces/IDatacapGateway.sol";

contract StorageProviderEscrow is Ownable {
    address public usdcAddr;

    address public datacapGatewayAddr;

    uint256 public id;

    uint256 public remainingDatacap;

    constructor(address initialOwner, address usdcAddress, address datacapGatewayAddress, uint256 newId) Ownable(initialOwner) {
        id = newId;
        usdcAddr = usdcAddress;
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

    // ERC20 methods

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    // FIXME: SP access only
    function transfer(address to, uint256 value) external returns (bool) {
        IERC20 usdc = IERC20(usdcAddr);
        return usdc.transfer(to, value);
    } 

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    // FIXME: SP access only
    function approve(address spender, uint256 value) external returns (bool) {
        IERC20 usdc = IERC20(usdcAddr);
        return usdc.approve(spender, value);
    }
}