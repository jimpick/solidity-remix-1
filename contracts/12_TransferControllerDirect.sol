// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IMockAllocator} from "../interfaces/IMockAllocator.sol";

// Contract that interacts with main USDC contract to transfer tokens
// and Axelar bridge to grant datacap

contract TransferControllerDirect is Ownable {
    // Address of USDC contract
    address public usdcContractAddress;

    // Address of Mock Allocator
    address public mockAllocator;

    // Create a pointer to the USDC contract
    constructor(address initialOwner, address _usdcContractAddress, address _mockAllocator) Ownable(initialOwner) {
        usdcContractAddress = _usdcContractAddress;
        mockAllocator = _mockAllocator;
    }

    // Function to get USDC balance
    function getUsdcBalance() external view returns (uint256 balance) {
        // console.log("sender", msg.sender);
        IERC20 usdcContract = IERC20(usdcContractAddress);
        uint256 account_balance = usdcContract.balanceOf(msg.sender);
        // console.log("balance", balance);
        return account_balance;
    }

    function getUsdcBalance2(address _account)
        external
        view
        returns (uint256 balance)
    {
        require(_account != address(0), "Zero Address");
        IERC20 usdcContract = IERC20(usdcContractAddress);
        uint256 account_balance = usdcContract.balanceOf(_account);

        return account_balance;
    }

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFromAndGrantDatacap(address from, address to, uint256 value, bytes calldata clientFilecoinAddress, uint256 amount) external onlyOwner returns (bool)
    {
        IMockAllocator allocator = IMockAllocator(mockAllocator);
        allocator.addVerifiedClient(clientFilecoinAddress, amount);

        IERC20 usdcContract = IERC20(usdcContractAddress);
        bool success = usdcContract.transferFrom(from, to, value);

        return success;
    }

    function transferFromAndGrantDatacapMock(address from, address to, uint256 value, address clientFilecoinAddress, uint256 amount) external onlyOwner returns (bool)
    {
        IMockAllocator allocator = IMockAllocator(mockAllocator);
        allocator.addVerifiedClientMock(clientFilecoinAddress, amount);

        IERC20 usdcContract = IERC20(usdcContractAddress);
        bool success = usdcContract.transferFrom(from, to, value);

        return success;
    }
}
