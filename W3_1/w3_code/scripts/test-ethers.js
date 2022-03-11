const ethers = require("ethers");
const MyERC20Abi = require("../artifacts/contracts/MyERC20.sol/MyERC20.json")

async function main() {
    let url = "http://127.0.0.1:8545";
    let provider = new ethers.providers.JsonRpcProvider(url);
    let abi = MyERC20Abi.abi;
    let amount = "10000"
    let contractAddr = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
    console.log("铸币金额为:",amount)
    amount =  ethers.utils.parseUnits(amount).toString();

    let signer = provider.getSigner()

    let myERC20 = new ethers.Contract(contractAddr, abi, signer);

    await myERC20.mint("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266", amount);

    let balance = await myERC20.balanceOf("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266")

    console.log("铸币后余额为:", ethers.utils.formatUnits(balance, 18))
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
