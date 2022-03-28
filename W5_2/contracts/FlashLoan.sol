// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.10;

import "./FlashLoanSimpleReceiverBase.sol";
import "./interfaces/IPool.sol";
import "./interfaces/IPoolAddressesProvider.sol";
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
    address AtokenAddress = 0x2Ec4c6fCdBF5F9beECeB1b51848fc2DB1f3a26af;
    address BtokenAddress = 0x53905Fc9218900c15c9f4d85E46Bf9204AA8F2c7;
    address[]  path;
    constructor(address _addressProvider)
    FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider))
    {
        path.push(AtokenAddress);
        path.push(BtokenAddress);
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
        //V2兑换
        IERC20(AtokenAddress).approve(v2Router, amount);
        uint256[] memory amounts  = IV2SwapRouter(v2Router).swapExactTokensForTokens(amount, 0, path, address(this), block.timestamp);

        //V3兑换
        IERC20(BtokenAddress).approve(v3Router, amounts[1]);

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
        amountIn: amounts[1],
        amountOutMinimum: 0
        })
        );
        //授权给Pool合约地址 进行还款
        IERC20(AtokenAddress).approve(ADDRESSES_PROVIDER.getPool(), totalDebt);
        return true;
    }
}
