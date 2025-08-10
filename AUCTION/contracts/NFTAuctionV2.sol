//SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTAuctionV2 is Initializable, UUPSUpgradeable {
    // 结构体 拍卖
    struct Auction {
        // 卖家
        address seller;
        // 拍卖持续时间
        uint256 duration;
        // 起始价格
        uint256 startPrice;
        // 拍卖开始时间
        uint256 startTime;
        // 是否已售出
        bool ended;
        // 最高价所有者
        address highestBidder;
        // 最高价
        uint256 highestBid;
        // NTF地址
        address nftContract;
        // NTF ID
        uint256 tokenId;
    }

    // 状态变量
    mapping(uint256 => Auction) public auctions;

    // 下一个拍卖ID
    uint256 public nextAuctionId;

    // 管理员的地址
    address public admin;

    // 构造函数
    function initialize() public initializer{
        admin = msg.sender;
    }

    function createAuction(uint256 _duration, uint256 _startPrice, address _nftContract, uint256 _tokenId) external {
        // 只有管理员可以创建拍卖
        require(msg.sender == admin, "Only admin can create auction");
        require(
            _duration >= 10,
            "Duration must be greater than 10 seconds"
        );
        require(_startPrice > 0, "Start price must be greater than 0");
        auctions[nextAuctionId] = Auction({
            seller: msg.sender,
            duration: _duration,
            startPrice: _startPrice,
            startTime: block.timestamp,
            ended: false,
            highestBidder: address(0),
            highestBid: 0,
            nftContract: _nftContract,
            tokenId: _tokenId
        });

        nextAuctionId++;
    }

    // 卖家参与竞拍
    function bid(uint256 _auctionId) public payable {
        // 获取拍卖信息
        Auction storage auction = auctions[_auctionId];
        require(!auction.ended, "Auction has ended");
        require(
            msg.value > auction.highestBid && msg.value >= auction.startPrice,
            "Bid must be higher than the current highest bid"
        );
        require(
            block.timestamp < auction.startTime + auction.duration,
            "Auction has ended"
        );
        require(
            msg.sender != auction.seller,
            "Seller cannot bid on their own auction"
        );

        if (auction.highestBid != 0) {
            // Refund the previous highest bidder
            payable(auction.highestBidder).transfer(auction.highestBid);
        }
        auction.highestBid = msg.value;
        auction.highestBidder = payable(msg.sender);
    }

    function testUpgrade() public pure returns (string memory) {
        return "testUpgrade";
    }

    /**
     * 使用UUPS 升级合约
    */
    function _authorizeUpgrade(address) internal override view {
        // 只有管理员可以升级合约
        require(msg.sender == admin, "Only admin can upgrade the contract");
    }
}
