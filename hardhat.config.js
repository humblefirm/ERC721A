require('@nomiclabs/hardhat-waffle');
require('@nomiclabs/hardhat-ethers');
require('@nomiclabs/hardhat-etherscan');

const ALCHEMY_API_KEY = '24KZy6wbWKjIt7JYdmCbZk4G2pE-Hyd_';

const ROPSTEN_PRIVATE_KEY = '31ff8203ba500b62ad1ea5ba3c15fb38bc8a400a37f81e8f70a0839d053df479';

if (process.env.REPORT_GAS) {
  require('hardhat-gas-reporter');
}

if (process.env.REPORT_COVERAGE) {
  require('solidity-coverage');
}

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    version: '0.8.11',
    settings: {
      optimizer: {
        enabled: true,
        runs: 800,
      },
    },
  },
  gasReporter: {
    currency: 'USD',
    gasPrice: 100,
    showTimeSpent: true,
  },
  plugins: ['solidity-coverage'],
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: 'XAHHUFHKKK6RHEXEPEY8I45NCYYPPEBA6Z',
  },
  networks: {
    rinkeby: {
      url: `https://eth-rinkeby.alchemyapi.io/v2/24KZy6wbWKjIt7JYdmCbZk4G2pE-Hyd_`,
      accounts: [`${ROPSTEN_PRIVATE_KEY}`],
    },
  },
};
