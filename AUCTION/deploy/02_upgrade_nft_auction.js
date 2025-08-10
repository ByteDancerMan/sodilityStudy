// deploy/01_deploy_nft_auction.js

const {deployments, upgrades, ethers} = require('hardhat');

const fs = require('fs');//fileStream
const path = require('path');//path,node.js处理路径

module.exports = async ({getNamedAccounts, deployments}) => {
    const {save} = deployments;
    const {deployer} = await getNamedAccounts();

    console.log("部署用户地址：", deployer);
    
    // .cache/proxyNFTAuction.json读取代理合约信息
    const storePath = path.resolve(__dirname, './.cache/proxyNFTAuction.json');
    const proxyData = fs.readFileSync(storePath, 'utf-8');
    const {proxyAddress, implAddress, abi} = JSON.parse(proxyData);

    // 升级版的业务合约
    const NFTAuctionV2 = await ethers.getContractFactory("NFTAuctionV2");
    const nftAuctionV2 = await upgrades.upgradeProxy(proxyAddress, NFTAuctionV2);
    await nftAuctionV2.waitForDeployment();
    const nftAuctionV2Address = await nftAuctionV2.getAddress();
    console.log("升级后的合约地址：", nftAuctionV2Address);
    // 实现合约地址
    const implAddress2 = await upgrades.erc1967.getImplementationAddress(nftAuctionV2Address);
    console.log("实现合约地址：", implAddress2);
    
    // 保存升级后的合约信息
    await save("NFTAuctionProxyV2", {
        abi,
        address: nftAuctionV2Address,
    });
    
};

module.exports.tags = ['upgradeNFTAuction']; 