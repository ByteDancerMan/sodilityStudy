const {ethers, deployments} = require("hardhat");
const {expect} = require("chai");

describe("测试ERC721", function () { 
    it("test ok", async function () { 
        await main();
    });

});

async function main() { 

    // 1.部署业务合约
    await deployments.fixture(["deployNFTAuction"]);
    // 2.获取合约
    const nftAuctionProxy = await deployments.get("NFTAuctionProxy");

    // 获取部署者
    const [signer, buyer] = await ethers.getSigners();

    // 3.部署ERC721合约
    const TestERC721 = await ethers.getContractFactory("TestERC721");
    const testERC721 = await TestERC721.deploy();
    await testERC721.waitForDeployment();
    const testERC721Address = await testERC721.getAddress();
    console.log("testERC721合约地址::", testERC721Address);

    // 4.调用 mint 方法给合约账户 mint 10 个 NFT
    for (let i = 0; i < 10; i++) {
        await testERC721.mint(signer.address, i + 1);
    }

    const tokenId = 1;

    // 5.调用 createAuction 方法创建拍卖
    console.log("开始创建拍卖::", nftAuctionProxy.address);
    
    // 使用部署的合约实例
    const NFTAuction = await ethers.getContractFactory("NFTAuction");
    const nftAuction = NFTAuction.attach(nftAuctionProxy.address);
    console.log("合约实例创建成功");

    // 6.给代理合约授权
    await testERC721.connect(signer).setApprovalForAll(nftAuctionProxy.address, true);

    await nftAuction.createAuction(
        10,
        ethers.parseEther("0.00000000000000001"),
        testERC721Address,
        tokenId
    );

    // 6.获取拍卖信息
    const auction = await nftAuction.auctions(0)
    console.log("创建拍卖成功:", auction);


    // 7.购买者参与拍卖
    await nftAuction.connect(buyer).bid(0, {value: ethers.parseEther("0.0000000000000001")});

    // 8.结束拍卖
    // 等待10s
    await new Promise(resolve => setTimeout(resolve, 10 * 1000));
    await nftAuction.connect(signer).endAuction(0);

    // 9.验证结果
    const auctionResult = await nftAuction.auctions(0);
    console.log("拍卖结果::", auctionResult);
    expect(auctionResult.highestBidder).to.equal(buyer.address);
    expect(auctionResult.highestBid).to.equal(ethers.parseEther("0.0000000000000001"));

    // 10.验证 NFT 所有权
    const owner = await testERC721.ownerOf(tokenId);
    console.log("nft owner::", owner);
    expect(owner).to.equal(buyer.address);
}
