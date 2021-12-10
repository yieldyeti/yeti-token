async function main() {
  // const baseTokenURI = "ipfs://QmZbWNKJPAjxXuNFSEaksCJVd1M6DaKQViJBYPK2BdpDEP/";
  const [owner] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", owner.address, ", Balance:", (await owner.getBalance()).toString());

  const YetiNFT = await ethers.getContractFactory("YetiNFT");
  // const yetinft = await YetiNFT.deploy(baseTokenURI);
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