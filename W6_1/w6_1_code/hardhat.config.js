require("@nomiclabs/hardhat-waffle");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

const PRI = "xxx";

module.exports = {
  //部署网络
  defaultNetwork: "hardhat",
  networks: {
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/xxx`,
      accounts: [`0x${PRI}`],
      chainId: 4,
      gas:5000000
    },
    goerli: {
      url: `https://goerli.infura.io/v3/xxx`,
      accounts: [`0x${PRI}`],
      chainId: 5
    },
    bsctest: {
      url: `https://data-seed-prebsc-1-s1.binance.org:8545`,
      accounts: [`0x${PRI}`],
      chainId: 97
    },
    okextest: {
      url: `https://exchaintestrpc.okex.org`,
      accounts: [`0x${PRI}`],
      gasPrice:5000000000,
      chainId: 65
    },
    dev: {
      url: "http://127.0.0.1:8545",
      chainId: 31337,
    },
  },
  solidity: {
    // 编译版本
    compilers: [
      {
        version: "0.8.10",
        settings: {}
      },
    ]
  },
  //编译以后的文件路径
  paths: {
    // 合约来源
    sources: "./contracts",
    // 测试文件
    tests: "./test",
    // 缓存目录
    cache: "./cache",
    // 编译目录
    artifacts: "./artifacts"
  }
};
