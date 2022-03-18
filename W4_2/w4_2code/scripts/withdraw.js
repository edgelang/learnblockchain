// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const {ethers} = require("hardhat");

async function main() {
    const [account] = await ethers.getSigners();
    const myTokenMarket = await ethers.getContractAt("MyTokenMarket", "0x5C0D358308eae17D35F54BEb2D1a1aF82daC1432", account);
    const myTokenMarketTx = await myTokenMarket.withdraw();
    await myTokenMarketTx.wait();

    console.log("提取成功")
    // const counterValue = await counter.counter()
    //
    // console.log("counter new value:", counterValue);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
