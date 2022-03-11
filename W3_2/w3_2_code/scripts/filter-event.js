const ethers = require("ethers");
const MyERC721Abi = require("../artifacts/contracts/MyERC721.sol/MyERC721.json")
const mysql = require('mysql2/promise');

async function main() {

    //连接数据库
    let connection = mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: '123456',
        database: 'test',
        port: '3306'
    });

    await  (await connection).connect();
    let url = "https://data-seed-prebsc-1-s1.binance.org:8545";
    let provider = new ethers.providers.JsonRpcProvider(url);
    let erc721 = new ethers.Contract("0xd29381Bb78Da3ab5c382F55E204cA364ebc8499E", MyERC721Abi.abi, provider);
    let filter = erc721.filters.Transfer()
// 选择区块区间
    filter.fromBlock = 17460020 ;
    filter.toBlock = 17460120 ; // "latest";
// 获取⽇志
    let logs = await provider.getLogs(filter);

    console.log(logs)

    //解析日志
    const TransferEvent = new ethers.utils.Interface(["event Transfer(address indexed from, address indexed to, uint256 indexed tokenId)"]);
    for (let i = 0; i < logs.length; i++) {
        let data = TransferEvent.parseLog(logs[i]);
        //插入数据库
        await (await connection).execute('INSERT INTO nft (nftnum, from, to) VALUES (?, ?, ?)',
                [data.args.tokenId.toString(), data.args.from.toString(), data.args.to.toString()]
            )
        console.log("from:" + data.args.from);
        console.log("to:" + data.args.to);
        console.log("tokenId:" + data.args.tokenId);
    }
    // const data = TransferEvent.parseLog(logs[i])
    // console.log("from:" + data.args.from)
    // console.log("from:" + data.args.to)
    //let logs = await erc721.queryFilter(filterTo, -10, "latest");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
