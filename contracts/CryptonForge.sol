// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CryptonForge
 * @dev A decentralized minting platform that allows users to create tokens (forged assets),
 * view total minted assets, and transfer ownership securely.
 */

contract CryptonForge {
    struct Asset {
        address creator;
        string name;
        uint256 value;
        uint256 timestamp;
    }

    Asset[] public assets;
    address public owner;

    event AssetForged(address indexed creator, string name, uint256 value);
    event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);

    constructor() {
        owner = msg.sender;
    }

    // 🧱 Function 1: Mint (Forge) a new asset
    function forgeAsset(string calldata _name, uint256 _value) external {
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(_value > 0, "Value must be positive");

        assets.push(Asset(msg.sender, _name, _value, block.timestamp));
        emit AssetForged(msg.sender, _name, _value);
    }

    // 🔍 Function 2: Get total number of forged assets
    function getTotalAssets() external view returns (uint256) {
        return assets.length;
    }

    // 🔑 Function 3: Transfer ownership
    function transferOwnership(address _newOwner) external {
        require(msg.sender == owner, "Only owner can transfer ownership");
        require(_newOwner != address(0), "Invalid address");

        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }
}
