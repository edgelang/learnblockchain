// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const {ethers} = require("hardhat");

async function main() {
    // Hardhat always runs the compile task when running scripts with its command
    // line interface.
    //
    // If this script is run directly using `node` you may want to call compile
    // manually to make sure everything is compiled
    // await hre.run('compile');

    // We get the contract to deploy
    const [account] = await ethers.getSigners();
    const masterChef = await ethers.getContractAt("MasterChef", "0x26434f513b98178AF4e0F884f00886346E688AFc", account);
    const myToken = await ethers.getContractAt("MyToken", "0x54A51a039e7151dB37518b201A6aadD4A14CA29d", account);
    const myTokenTx = await myToken.approve("0x26434f513b98178AF4e0F884f00886346E688AFc", "10000000000000000000000000000000000");

    // wait until the transaction is mined
    await myTokenTx.wait();

    console.log("授权成功")

    const masterChefTx = await masterChef.deposit(0, ethers.utils.parseEther('10000'));
    await masterChefTx.wait();
    console.log("质押成功")
    // const myTokenMarketTx = await myTokenMarket.AddLiquidity(ethers.utils.parseEther('10000'),{value: ethers.utils.parseEther('0.1')})
    // await myTokenMarketTx.wait();
    //
    // console.log("添加流动性成功")
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
