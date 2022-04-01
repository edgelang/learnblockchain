# 区块链技术集训营第六周第一堂课作业

## * 设计一个看涨期权Token:
## 创建期权Token 时，确认标的的价格与行权日期；
## 发行方法（项目方角色）：根据转入的标的（ETH）发行期权Token；
## 行权方法（用户角色）：在到期日当天，可通过指定的价格兑换出标的资产，并销毁期权Token
## 过期销毁（项目方角色）：销毁所有期权Token 赎回标的。

[CallOptToken.sol](./w6_1_code/contracts/CallOptToken.sol)
[CallOptTokenFactory.sol](./w6_1_code/contracts/CallOptTokenFactory.sol)

发行期权Token 交易hash：

https://goerli.etherscan.io/tx/0xd3c7cade7047cf348323c3aa49d22f62d24306857eaf8890d7c1cba0dd0f2401

行权交易hash：
https://goerli.etherscan.io/tx/0x71bda8208eeb9248dea891210584bd5ea32a8b77b3c5ab4745a59bdf277e20d7

过期销毁 交易hash：
https://goerli.etherscan.io/tx/0x3779353a6367193b0e4e962169de5fc5194c71ca79652c9ff84f231c9536f4a6