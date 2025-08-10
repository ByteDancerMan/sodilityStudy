// deploy/01_deploy_nft_auction.js

const {deployments, upgrades, ethers} = require('hardhat');

const fs = require('fs');//fileStream
const path = require('path');//path,node.js处理路径

module.exports = async ({getNamedAccounts, deployments}) => {
    const {save} = deployments;
    const {deployer} = await getNamedAccounts();

    console.log("部署用户地址：", deployer);
    
    // 修复：添加 await
    const NFTAuction = await ethers.getContractFactory("NFTAuction");

    // 通过代理部署合约
    const nftAuctionProxy = await upgrades.deployProxy(
        // 合约工厂
        NFTAuction,
        // 初始化参数
        [],
        {
            // 初始化方法
            initializer: 'initialize'
        }
    );

    await nftAuctionProxy.waitForDeployment();
    const proxyAddress = await nftAuctionProxy.getAddress();
    console.log("代理合约地址：", proxyAddress);
    const implAddress = await upgrades.erc1967.getImplementationAddress(proxyAddress);
    console.log("实现合约地址：", implAddress);

    const storePath = path.resolve(__dirname, './.cache/proxyNFTAuction.json');
    
    fs.writeFileSync(storePath, JSON.stringify({
        proxyAddress,
        implAddress,
        abi: NFTAuction.interface.format('json')
    }, null, 2));
    console.log("部署信息已保存到：", storePath);

    await save("NFTAuctionProxy", {
        abi: nftAuctionProxy.interface.format('json'),
        address: proxyAddress,
    });
};

module.exports.tags = ['deployNFTAuction']; 