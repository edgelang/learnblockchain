// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
    // Hardhat always runs the compile task when running scripts with its command
    // line interfaces.
    //
    // If this script is run directly using `node` you may want to call compile
    // manually to make sure everything is compiled
    // await hre.run('compile');

    // We get the contract to deploy

    //goerli测试网uniswap环境
    const router = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";
    const myToken = "0x54A51a039e7151dB37518b201A6aadD4A14CA29d";
    const weth = "0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6";
    const MyTokenMarket = await hre.ethers.getContractFactory("MyTokenMarket");
    const myTokenMarket = await MyTokenMarket.deploy(router, myToken, weth);

    await myTokenMarket.deployed();

    console.log("MyTokenMarket deployed to:", myTokenMarket.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
