? Function 1: Mint (Forge) a new asset
    function forgeAsset(string calldata _name, uint256 _value) external {
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(_value > 0, "Value must be positive");

        assets.push(Asset(msg.sender, _name, _value, block.timestamp));
        emit AssetForged(msg.sender, _name, _value);
    }

    ? Function 3: Transfer ownership
    function transferOwnership(address _newOwner) external {
        require(msg.sender == owner, "Only owner can transfer ownership");
        require(_newOwner != address(0), "Invalid address");

        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }
}
// 
update
// 
