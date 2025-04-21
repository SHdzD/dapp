const hre = require("hardhat");

async function main() {
  const SavingsLoans = await hre.ethers.getContractFactory("SavingsLoans");
  const savingsLoans = await SavingsLoans.deploy();

  console.log("Contract deployment tx sent. Waiting for confirmation...");
  await savingsLoans.waitForDeployment();

  console.log(`SavingsLoans contract deployed to: ${savingsLoans.target}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });