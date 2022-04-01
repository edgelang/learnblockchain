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
    const CallOptTokenFactory = await hre.ethers.getContractFactory("CallOptTokenFactory");
    const callOptTokenFactory = await CallOptTokenFactory.deploy("0xE142f1D72CD7DBC9C544F21153Ed05eB1d33f4Ad");

    await callOptTokenFactory.deployed();

    console.log("CallOptTokenFactory deployed to:", callOptTokenFactory.address);

    const callOptTokenFactoryTx = await callOptTokenFactory.mintCallOptToken(1, 5000, 600, "0xE17281c17443b90A145d1a103d57189ffB2D912f",{value:ethers.utils.parseEther('1')})

    await callOptTokenFactoryTx.wait();
    console.log("铸造期权代币执行成功");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
