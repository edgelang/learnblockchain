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
    const CallOptTokenFactory = await ethers.getContractAt("CallOptTokenFactory", "0x5870AEa663b83C743be48ba02bF4479071768C78", account);

    const CallOptTokenFactoryTx = await CallOptTokenFactory.burnCallOptToken([1]);

    await CallOptTokenFactoryTx.wait();
    console.log("管理员销毁成功");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
