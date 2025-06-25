const { ethers } = require("hardhat");

async function main() {
  const NFTRaffle = await ethers.getContractFactory("NFTRaffle");
  const raffle = await NFTRaffle.deploy();

  await raffle.deployed();
  console.log("NFT Raffle Contract deployed to:", raffle.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
