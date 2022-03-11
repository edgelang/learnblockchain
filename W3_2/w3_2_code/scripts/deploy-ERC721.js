// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
    // Hardhat always runs the compile task when running scripts with its command
    // line interface.
    //
    // If this script is run directly using `node` you may want to call compile
    // manually to make sure everything is compiled
    // await hre.run('compile');

    // We get the contract to deploy
    const MyERC721 = await hre.ethers.getContractFactory("MyERC721");
    const myERC721 = await MyERC721.deploy();

    await myERC721.deployed();

    console.log("MyERC721 deployed to:", myERC721.address);

    //铸造10个nft代币
    for (let i = 1; i <= 10; i++) {
        await myERC721.mint("0xE17281c17443b90A145d1a103d57189ffB2D912f",i)
    }

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
