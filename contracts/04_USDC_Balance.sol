pragma solidity ^0.8.4;

import "hardhat/console.sol";

interface MainUsdcContractInterface {
    // Define signature of balanceOf
    function balanceOf(address owner) external view returns (uint256);
}

// Contract that interacts with main USDC contract to get balance of a wallet
contract UsdcBalance {

    // Address of USDC contract
    address public usdcContractAddress;
    MainUsdcContractInterface usdcContract;
    
    // Create a pointer to the USDC contract
    constructor(address _usdcContractAddress) {
        usdcContractAddress = _usdcContractAddress;
        usdcContract = MainUsdcContractInterface(usdcContract);
    }

    // Function to get USDC balance
    function getUsdcBalance() public view returns (uint) {
        uint balance = usdcContract.balanceOf(msg.sender);
        return balance;
    }
}
