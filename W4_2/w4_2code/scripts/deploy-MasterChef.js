// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const {ethers} = require("hardhat");

async function main() {
    // Hardhat always runs the compile task when running scripts with its command
    // line interfaces.
    //
    // If this script is run directly using `node` you may want to call compile
    // manually to make sure everything is compiled
    // await hre.run('compile');

    // We get the contract to deploy
    const SushiToken = await hre.ethers.getContractFactory("SushiToken");
    const sushiToken = await SushiToken.deploy();

    await sushiToken.deployed();

    console.log("SushiToken deployed to:", sushiToken.address);

    const MasterChef = await hre.ethers.getContractFactory("MasterChef");
    const masterChef = await MasterChef.deploy(sushiToken.address, "0xE17281c17443b90A145d1a103d57189ffB2D912f", ethers.utils.parseEther('50'), 6557232, 6567232);

    await masterChef.deployed();

    console.log("MasterChef deployed to:", masterChef.address);

    const sushiTokenTx = await sushiToken.transferOwnership(masterChef.address);

    await sushiTokenTx.wait();
    console.log("管理员权限转移成功");

    const masterChefTx = await masterChef.add(100, "0x54A51a039e7151dB37518b201A6aadD4A14CA29d", false)
    await masterChefTx.wait();
    console.log("masterChef 池子添加成功");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
