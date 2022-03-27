// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.10;

import "./FlashLoanSimpleReceiverBase";
import "./interfaces/IPool";
import "./interfaces/IPoolAddressesProvider";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

interface IV3SwapRouter {
    struct ExactInputParams {
        bytes path;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
    }

    function exactInput(ExactInputParams calldata params)
    external
    payable
    returns (uint256 amountOut);
}

interface IV2SwapRouter {
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
    external
    view
    returns (uint256[] memory amounts);
}

contract FlashLoan is FlashLoanSimpleReceiverBase {
    address v2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address v2Factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address v3Router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address AtokenAddress = 0x1d5Ab3979b42E09672E8Bd5d7ebDE21cdefFBb9E;
    address BtokenAddress = 0x6242d2260E7bE8D661692d99477A650d47BCF095;
    address[]  path;
    constructor(address _addressProvider)
        FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider))
    {
        path.push(0x1d5Ab3979b42E09672E8Bd5d7ebDE21cdefFBb9E);
        path.push(0x6242d2260E7bE8D661692d99477A650d47BCF095);
    }

    //借款单币种
    function loan(uint256 _amount) public {
        POOL.flashLoanSimple(address(this), AtokenAddress, _amount, "", 0);
    }

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external returns (bool) {
        uint256 totalDebt = amount + premium;
        address token0 = IUniswapV2Pair(tokenPairAddr).token0();
        address token1 = IUniswapV2Pair(tokenPairAddr).token1();
        uint256 amount0Out = AtokenAddress == token0 ? amount : 0;
        uint256 amount1Out = AtokenAddress == token1 ? amount : 0;
        //V2兑换
        IERC20(AtokenAddress).approve(v2Router, amount);
        uint256 amountB  = IV2SwapRouter(v2Router).swapExactTokensForTokens(amountIn, 0, path, address(this), block.timestamp);

        //V3兑换
        IERC20(AtokenAddress).approve(v3Router, amount);

        uint256 amountA = IV3SwapRouter(v3Router).exactInput{
        value: 0
        }(
            IV3SwapRouter.ExactInputParams({
        path: abi.encodePacked(
                BtokenAddress,
                uint24(10000),
                AtokenAddress
            ),
        recipient: address(this),
        deadline: block.timestamp,
        amountIn: amountB,
        amountOutMinimum: 0
        })
        );
        //授权给Pool合约地址 进行还款
        IERC20(AtokenAddress).approve(ADDRESSES_PROVIDER.getPool(), totalDebt);
        return true;
    }
}
