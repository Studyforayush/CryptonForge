Mapping tokenId to forging level (>=1)
    mapping(uint256 => uint256) public tokenLevels;

    event NFTMinted(address indexed to, uint256 indexed tokenId, string tokenURI);
    event NFTForged(address indexed owner, uint256[] burnedTokenIds, uint256 newTokenId, uint256 newLevel);

    constructor() ERC721("CryptonForge", "CFT") {}

    /**
     * @dev Owner can mint NFTs with initial level 1
     * @param to Receiver of NFT
     * @param tokenURI Metadata URI
     */
    function mintNFT(address to, string memory tokenURI) external onlyOwner returns (uint256) {
        _tokenIds++;
        uint256 newTokenId = _tokenIds;
        _safeMint(to, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        tokenLevels[newTokenId] = 1;

        emit NFTMinted(to, newTokenId, tokenURI);
        return newTokenId;
    }

    /**
     * @dev User can forge by burning multiple owned NFTs to mint a higher level NFT
     * @param tokenIds Token IDs user owns to burn
     * @param newTokenURI Metadata URI for new forged NFT
     */
    function forgeNFT(uint256[] calldata tokenIds, string calldata newTokenURI) external returns (uint256) {
        require(tokenIds.length >= 2, "At least two NFTs required to forge");

        uint256 totalLevel = 0;

        Burn old tokens
        for (uint256 i = 0; i < tokenIds.length; i++) {
            _burn(tokenIds[i]);
            delete tokenLevels[tokenIds[i]];
        }

        Define new level as sum of levels (can be customized)
        tokenLevels[newTokenId] = totalLevel;

        emit NFTForged(msg.sender, tokenIds, newTokenId, totalLevel);

        return newTokenId;
    }

    /**
     * @dev Returns the forging level of a token
     * @param tokenId Token ID
     */
    function getTokenLevel(uint256 tokenId) external view returns (uint256) {
        require(_exists(tokenId), "Nonexistent token");
        return tokenLevels[tokenId];
    }
}
// 
End
// 
