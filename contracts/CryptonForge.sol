// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title CryptonForge
 * @dev Simple on-chain asset forge for registering and updating hashed artifacts
 * @notice Users can forge new assets identified by hashes and maintain versioned metadata URIs
 */
contract CryptonForge {
    address public owner;

    struct ForgeAsset {
        address creator;
        bytes32 assetHash;     // hash of the off-chain artifact / content
        string  name;          // human-readable name
        string  uri;           // metadata or content URI
        uint256 version;       // version counter
        uint256 createdAt;
        uint256 updatedAt;
        bool    isActive;
    }

    // assetId => ForgeAsset
    mapping(uint256 => ForgeAsset) public assets;

    // creator => assetIds[]
    mapping(address => uint256[]) public assetsOf;

    // assetHash => latest assetId (first forge defines identity)
    mapping(bytes32 => uint256) public latestByHash;

    uint256 public nextAssetId;

    event AssetForged(
        uint256 indexed assetId,
        address indexed creator,
        bytes32 indexed assetHash,
        string name,
        string uri,
        uint256 version,
        uint256 timestamp
    );

    event AssetUpdated(
        uint256 indexed assetId,
        string name,
        string uri,
        uint256 version,
        uint256 timestamp
    );

    event AssetStatusUpdated(
        uint256 indexed assetId,
        bool isActive,
        uint256 timestamp
    );

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier assetExists(uint256 assetId) {
        require(assets[assetId].creator != address(0), "Asset not found");
        _;
    }

    modifier onlyCreator(uint256 assetId) {
        require(assets[assetId].creator == msg.sender, "Not creator");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Forge a new asset from a content hash
     * @param assetHash Hash of the artifact
     * @param name Human-readable name
     * @param uri Metadata/content URI
     */
    function forgeAsset(
        bytes32 assetHash,
        string calldata name,
        string calldata uri
    ) external returns (uint256 assetId) {
        require(assetHash != bytes32(0), "Invalid hash");

        assetId = nextAssetId++;
        ForgeAsset storage a = assets[assetId];

        a.creator = msg.sender;
        a.assetHash = assetHash;
        a.name = name;
        a.uri = uri;
        a.version = 1;
        a.createdAt = block.timestamp;
        a.updatedAt = block.timestamp;
        a.isActive = true;

        assetsOf[msg.sender].push(assetId);
        latestByHash[assetHash] = assetId;

        emit AssetForged(
            assetId,
            msg.sender,
            assetHash,
            name,
            uri,
            1,
            block.timestamp
        );
    }

    /**
     * @dev Update name/uri of an existing asset (increments version)
     * @param assetId Asset identifier
     * @param name New name
     * @param uri New URI
     */
    function updateAsset(
        uint256 assetId,
        string calldata name,
        string calldata uri
    )
        external
        assetExists(assetId)
        onlyCreator(assetId)
    {
        ForgeAsset storage a = assets[assetId];
        require(a.isActive, "Inactive asset");

        a.name = name;
        a.uri = uri;
        a.version += 1;
        a.updatedAt = block.timestamp;

        // keep latestByHash pointing at most recently updated asset for this hash
        latestByHash[a.assetHash] = assetId;

        emit AssetUpdated(assetId, name, uri, a.version, block.timestamp);
    }

    /**
     * @dev Activate/deactivate an asset
     * @param assetId Asset identifier
     * @param active New active state
     */
    function setAssetActive(uint256 assetId, bool active)
        external
        assetExists(assetId)
        onlyCreator(assetId)
    {
        assets[assetId].isActive = active;
        emit AssetStatusUpdated(assetId, active, block.timestamp);
    }

    /**
     * @dev Get all assetIds created by a given address
     */
    function getAssetsOf(address user) external view returns (uint256[] memory) {
        return assetsOf[user];
    }

    /**
     * @dev Transfer protocol ownership
     */
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Zero address");
        address prev = owner;
        owner = newOwner;
        emit OwnershipTransferred(prev, newOwner);
    }
}
