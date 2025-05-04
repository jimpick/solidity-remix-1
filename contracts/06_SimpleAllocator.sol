// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.0;


import {Ownable2StepUpgradeable} from "@openzeppelin/contracts-upgradeable/access/Ownable2StepUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {ISimpleAllocator} from "./interfaces/ISimpleAllocator.sol";
import {VerifRegAPI} from "../lib/filecoin-solidity/contracts/v0.8/VerifRegAPI.sol";
import {VerifRegTypes} from "../lib/filecoin-solidity/contracts/v0.8/types/VerifRegTypes.sol";
import {DataCapAPI} from "../lib/filecoin-solidity/contracts/v0.8/DataCapAPI.sol";
import {CommonTypes} from "../lib/filecoin-solidity/contracts/v0.8/types/CommonTypes.sol";
import {FilAddressIdConverter} from "../lib/filecoin-project-filecoin-solidity/contracts/v0.8/utils/FilAddressIdConverter.sol";
import {FilAddresses} from "../lib/filecoin-solidity/contracts/v0.8/utils/FilAddresses.sol";
// import {BigInts} from "../lib/filecoin-solidity/contracts/v0.8/utils/BigInts.sol";
import {PrecompilesAPI} from "../lib/filecoin-solidity/contracts/v0.8/PrecompilesAPI.sol";
import {EnumerableMap} from "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";

contract SimpleAllocator is Initializable, Ownable2StepUpgradeable, ISimpleAllocator {
    using EnumerableMap for EnumerableMap.AddressToUintMap;

    /**
     * @notice Enumerable mapping from allocator addresses to their current
     * allowance
     */
    // EnumerableMap.AddressToUintMap private _allocators;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @notice Contract initializator. Should be called during deployment.
     * @param initialOwner Initial contract owner
     */
    function initialize(address initialOwner) public initializer {
        __Ownable_init(initialOwner);
    }

    event Name(string name);

    function name() public {
        string memory tokenName = DataCapAPI.name();
        emit Name(tokenName);
    }

    event BalanceBig(CommonTypes.BigInt balance);
    event Balance(uint256 balance);

   function balance() public {
        CommonTypes.FilAddress memory addr = FilAddresses.fromEthAddress(msg.sender);
        CommonTypes.BigInt memory result = DataCapAPI.balance(addr);
        emit BalanceBig(result);
    }

    /// @dev Error thrown when amount is invalid
    // 0x2c5211c6
    error InvalidAmount();

   /*
   function balanceFromActorID(uint64 actorID) public {
        CommonTypes.FilAddress memory addr = FilAddresses.fromActorID(actorID);
        CommonTypes.BigInt memory result = DataCapAPI.balance(addr);
        emit BalanceBig(result);
        (uint256 bal, bool failed) = BigInts.toUint256(result);
        if (failed) revert InvalidAmount();
        emit Balance(bal);
    }
    */

    function senderAddr() public view returns (address addr) {
        addr = msg.sender;
    }


    event FilAddr(CommonTypes.FilAddress addr);

    function filAddr() public {
        CommonTypes.FilAddress memory addr = FilAddresses.fromEthAddress(msg.sender);
        emit FilAddr(addr);
    }

    /**
     * @notice Grant allowance to a client.
     * @param clientAddress Filecoin address of the client
     * @param amount Amount of datacap to grant
     * @dev Emits DatacapAllocated event
     * @dev Reverts with InsufficientAllowance if caller doesn't have sufficient allowance
     * @custom:oz-upgrades-unsafe-allow-reachable delegatecall
     */
    function addVerifiedClient(bytes calldata clientAddress, uint256 amount) external {
        if (amount == 0) revert AmountEqualZero();
        /*
        uint256 allocatorBalance = allowance(msg.sender);
        if (allocatorBalance < amount) revert InsufficientAllowance();
        if (allocatorBalance - amount == 0) {
            _allocators.remove(msg.sender);
        } else {
            _allocators.set(msg.sender, allocatorBalance - amount);
        }
        */
        emit DatacapAllocated(msg.sender, clientAddress, amount);
        VerifRegTypes.AddVerifiedClientParams memory params = VerifRegTypes.AddVerifiedClientParams({
            addr: FilAddresses.fromBytes(clientAddress),
            allowance: CommonTypes.BigInt(abi.encodePacked(amount), false)
        });
        VerifRegAPI.addVerifiedClient(params);
    }

    function addVerifiedClientByActorID(uint64 actorID, uint256 amount) external {
        if (amount == 0) revert AmountEqualZero();
        /*
        uint256 allocatorBalance = allowance(msg.sender);
        if (allocatorBalance < amount) revert InsufficientAllowance();
        if (allocatorBalance - amount == 0) {
            _allocators.remove(msg.sender);
        } else {
            _allocators.set(msg.sender, allocatorBalance - amount);
        }
        */
        CommonTypes.FilAddress memory addr = FilAddresses.fromActorID(actorID);

        // emit DatacapAllocated(msg.sender, clientAddress, amount);
        VerifRegTypes.AddVerifiedClientParams memory params = VerifRegTypes.AddVerifiedClientParams({
            addr: addr,
            allowance: CommonTypes.BigInt(abi.encodePacked(amount), false)
        });
        VerifRegAPI.addVerifiedClient(params);
    }

    function getAddrBytesFromActorID(uint64 actorID) public pure returns (bytes memory){
        CommonTypes.FilAddress memory addr = FilAddresses.fromActorID(actorID);
        return addr.data;
    }

    function getEthAddrFromActorID(uint64 actorID) public view returns (address){
        // CommonTypes.FilAddress memory filecoinAddr = FilAddresses.fromActorID(actorID);
        address addr = FilAddressIdConverter.toAddress(actorID);
        return addr;
        // return toEthAddress(filecoinAddr);
    }

    function getEthAddrFromBytes(bytes calldata clientAddress) public view returns (address){
        CommonTypes.FilAddress memory filecoinAddr = FilAddresses.fromBytes(clientAddress);
        uint64 actorID = PrecompilesAPI.resolveAddress(filecoinAddr);
        address addr = FilAddressIdConverter.toAddress(actorID);
        return addr;
    }

    /// @dev Protocol byte values
    /// @notice These constants represent the byte value for each protocol.
    ///         For more information see the Filecoin documentation: 
    ///         https://docs.filecoin.io/smart-contracts/filecoin-evm-runtime/address-types
    bytes1 constant PROTOCOL_DELEGATED = hex"04";
 
    /// @dev EAM actor ID
    /// @notice This constant represents the EAM actor ID.
    bytes1 constant EAM_ID = hex"0a";

    /// @dev Protocols address lengths
    /// @notice These constants represent the address lengths for each protocol.
    ///         For more information see the Filecoin specification: 
    ///         https://spec.filecoin.io/#section-appendix
    uint256 constant PROTOCOL_DELEGATED_EAM_ADDRESS_LENGTH = 22;

    error InvalidAddress();

    /// @notice allow to get a eth address from 040a type FilAddress made above
    /// @param addr FilAddress to convert
    /// @return new eth address
    function toEthAddress(CommonTypes.FilAddress memory addr) internal pure returns (address) {
        if (
            addr.data[0] != PROTOCOL_DELEGATED || addr.data[1] != EAM_ID
                || addr.data.length != PROTOCOL_DELEGATED_EAM_ADDRESS_LENGTH
        ) {
            revert InvalidAddress();
        }
        bytes memory filAddress = addr.data;
        bytes20 ethAddress;

        assembly {
            ethAddress := mload(add(filAddress, 0x22))
        }

        return address(ethAddress);
    }

}
