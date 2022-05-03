const hre = require('hardhat');

async function main() {
  const Metanism = await hre.ethers.getContractFactory('ERC721AMetanism');
  const metanism = await Metanism.deploy('Metanism NFT', 'MNS');

  await metanism.deployed();

  console.log('metanism deployed to:', metanism.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
