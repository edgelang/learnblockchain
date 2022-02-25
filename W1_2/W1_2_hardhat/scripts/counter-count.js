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
    const counter = await ethers.getContractAt("Counter", "0x49cce04e013eaA5AB54CAEd9C7E749f872a72b4A", account);
    const countTx = await counter.count();

    // wait until the transaction is mined
    await countTx.wait();

    const counterValue = await counter.counter()

    console.log("counter new value:", counterValue);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
