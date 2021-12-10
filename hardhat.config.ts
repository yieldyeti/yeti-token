import { HardhatUserConfig } from "hardhat/types";
import "@nomiclabs/hardhat-waffle";
import "hardhat-typechain";
import "@nomiclabs/hardhat-etherscan";

const { pkey, INFURA_KEY, ETHERSCAN_API_KEY} = require('./secret.json');

const config: HardhatUserConfig = {
  defaultNetwork: "hardhat", 
  solidity: {
    compilers: [{ version: "0.8.0", settings: {optimizer : { enabled: true, runs: 1}} }],
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY
  },
  networks: {
    hardhat: {
        throwOnTransactionFailures: true,
        throwOnCallFailures: true,
    },
    mainnet: {
      url: `https://mainnet.infura.io/v3/${INFURA_KEY}`,
      chainId: 1,
      gasPrice: 20000000000,
      accounts: [`0x${pkey}`],
    },
    ropsten: {
      url: `https://ropsten.infura.io/v3/${INFURA_KEY}`,
      chainId: 3,
      gasPrice: 20000000000,
      accounts: [`0x${pkey}`],
    },
  }
};

export default config;