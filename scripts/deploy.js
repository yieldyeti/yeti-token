async function main() {
  const [owner] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", owner.address, ", Balance:", (await owner.getBalance()).toString());

  const YetiToken = await ethers.getContractFactory("YetiToken");
  const yetitoken = await YetiToken.deploy();
  await yetitoken.deployed();
  console.log("Yeti Token deployed to:", yetitoken.address);

  const YetiNFT = await ethers.getContractFactory("YetiNFT");
  const yetinft = await YetiNFT.deploy();
  await yetinft.deployed();
  console.log("Yeti NFT deployed to:", yetinft.address);

  txn = await yetinft.mint();
  await txn.wait()
  console.log("Token minted");
  let tokens = await yetinft.tokensOfOwner(owner.address)
  console.log("Owner has tokens: ", tokens);

  const Storage = await hre.ethers.getContractFactory("Storage");
  const storage = await Storage.deploy();
  await storage.deployed();
  console.log("Storage contract deployed to:", storage.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
      console.error(error);
      process.exit(1);
  });