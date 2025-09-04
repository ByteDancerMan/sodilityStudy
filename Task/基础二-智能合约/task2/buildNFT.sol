//SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract myNFT is ERC721, Ownable {
    
    uint256 private _tokenId;

    mapping(uint256 => string) private _tokenURIs;  // 存储每个NFT的tokenURI

    // 构造函数传入名称和符号，调用父类的构造函数
    constructor(address init, string memory name, string memory symbol) ERC721(name, symbol) Ownable(init) {
        _tokenId = 0;
    }

    function mintNFT(address to, string memory tokenURI) public onlyOwner returns (uint256) {
        _tokenId++;  // 增加_tokenId，确保每个NFT有唯一ID
        _safeMint(to, _tokenId);  // 创建新的NFT
        _setTokenURI(_tokenId, tokenURI);  // 设置新的tokenURI
        return _tokenId;  // 返回当前mint的NFT的ID
    }

    // 内部函数：为tokenId设置或更新tokenURI
    function _setTokenURI(uint256 tokenId, string memory tokenURI) internal {
        _tokenURIs[tokenId] = tokenURI;
    }

    // 公共函数：供外部读取tokenURI
    function getokenURI(uint256 tokenId) public view returns (string memory) {
        return _tokenURIs[tokenId];  // 返回tokenId对应的tokenURI
    }
}