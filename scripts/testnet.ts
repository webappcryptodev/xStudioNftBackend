import { ethers } from 'hardhat';

import { writeFileSync } from 'fs';

import { join } from 'path';

import { exit } from 'process';

require('dotenv');

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log('DEPLOYING CONTRACT WITH THE ACCOUNT :', deployer.address);

  console.log('DEPLOYER ACCOUNT BALANCE:', (await deployer.getBalance()).toString());

  const Market = await ethers.getContractFactory('NFTMarket');

  const NFTMarket = await Market.deploy();

  await NFTMarket.deployed();

  console.log('NFT GLOBAL TESTNET MARKET DEPLOYED TO:', NFTMarket.address);

  const NFT = await ethers.getContractFactory('NFTG');

  const TOKEN = await NFT.deploy('NFT GLOBAL TESTNET', 'NFTG', NFTMarket.address);

  await TOKEN.deployed();

  console.log('NFT GLOBAL TESTNET NFT DEPLOYED TO:', TOKEN.address);

  const config = `
  export const nftmarketaddress = "${NFTMarket.address}"
  export const nftaddress = "${TOKEN.address}"
  `;

  const data = JSON.stringify(config);

  writeFileSync(join(__dirname, '../../client/src/store/web3/testnet/config.js'), JSON.parse(data));

  const marketArtifacts = {
    address: NFTMarket.address,

    abi: JSON.parse(NFTMarket.interface.format('json') as string),
  };

  const tokenArtifacts = {
    address: TOKEN.address,

    abi: JSON.parse(TOKEN.interface.format('json') as string),
  };

  writeFileSync(join(__dirname, '../../client/src/store/web3/testnet/NFTG.json'), JSON.stringify(tokenArtifacts));

  writeFileSync(join(__dirname, '../../client/src/store/web3/testnet/Market.json'), JSON.stringify(marketArtifacts));
}

main()
  .then(() => exit(0))
  .catch((error) => {
    console.error(error);

    exit(1);
  });
