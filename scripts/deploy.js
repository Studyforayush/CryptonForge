const hre = require("hardhat");

async function main() {
  const CryptonForge = await hre.ethers.getContractFactory("CryptonForge");
  const cryptonForge = await CryptonForge.deploy();
  await cryptonForge.deployed();

  console.log("✅ CryptonForge deployed to:", cryptonForge.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
