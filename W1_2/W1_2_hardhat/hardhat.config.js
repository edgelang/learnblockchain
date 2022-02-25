require("@nomiclabs/hardhat-waffle");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

//账号私钥
const PRI = "xxxxxxx";

module.exports = {
  //部署网络
  defaultNetwork: "hardhat",
  networks: {
    okextest: {
      url: `https://exchaintestrpc.okex.org`,
      accounts: [`0x${PRI}`],
      chainId: 65
    }
  },
  solidity: {
    // 编译版本
    compilers: [
      {
        version: "0.8.12",
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

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

// /**
//  * @type import('hardhat/config').HardhatUserConfig
//  */
// module.exports = {
//   solidity: "0.8.4",
// };
