
const { ethers, deployments} = require('hardhat');
const { expect } = require('chai');

// describe("Starting", async function () { 


//     it("Should deploy the deploy", async function () { 
//         const contract = await ethers.GetConstractFactory("NFTAuction");
//         const nftAuction = await contract.deploy();
//         await nftAuction.waitForDeployment();

//         await contract.createAuction(
//             100 * 1000,
//             ethers.parseEther("0.00000000000000001"),
//             ethers.ZeroAddress,
//             1
//         );

//         const auction = await nftAuction.getAuction(1);
//     });

// });

describe("upgrade", async function () { 


    it("Should deploy the deploy", async function () { 
        // 1.部署业务合约
        await deployments.fixture(['deployNFTAuction']);
        const nftAuctionProxy = await deployments.get('NFTAuctionProxy');

        // 2.调用 createAuction 方法创建拍卖
        const nftAuction = await ethers.getContractAt("NFTAuction", nftAuctionProxy.address);

        await nftAuction.createAuction(
            100 * 1000,
            ethers.parseEther("0.00000000000000001"),
            ethers.ZeroAddress,
            1
        );
        // const implAddress1 = await upgrades.erc1967.getImplementationAddress(nftAuction.address);
        const auction = await nftAuction.auctions(0);
        console.log("创建拍卖成功:", auction); // 打印拍卖信息

        // 3.升级合约
        await deployments.fixture(['upgradeNFTAuction']);
        const nftAuctionV2 = await ethers.getContractAt("NFTAuctionV2", nftAuctionProxy.address);
        const upgrade = await nftAuctionV2.testUpgrade();
        console.log("升级后调用新方法成功:", upgrade);

        // 升级后实现合约地址
        // const implAddress = await upgrades.erc1967.getImplementationAddress(nftAuctionProxy.address);

        // 4.读取合约的 auction[0]
        const auction2 = await nftAuction.auctions(0);
        console.log("升级后读取拍卖成功: ", auction2);

        expect(auction2).to.deep.equal(auction);
        expect(auction2.startTime).to.equal(auction.startTime)
        // 5.验证实现合约的地址
        // expect(implAddress2).to.equal(implAddress1);
    });

});