const { ethers, upgrades } = require("hardhat");

async function main() {
  // Deploying the MediChain contract
  const MediChain = await ethers.getContractFactory("MediChain");
  console.log("Deploying MediChain contract...");
  const mediChain = await upgrades.deployProxy(MediChain, [], {
    initializer: "initialize",
  });
  await mediChain.deployed();
  console.log("MediChain contract deployed to:", mediChain.address);

  // Verifying the contract on Etherscan
  console.log("Verifying the contract on Etherscan...");
  await upgrades.verifyProxy(mediChain.address);
  console.log("Contract verified on Etherscan");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
