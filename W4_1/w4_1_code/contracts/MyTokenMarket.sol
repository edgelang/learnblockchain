// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IUniswapV2Router {
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);
}

contract MyTokenMarket {
    uint256 private constant UINT256_MAX = 2**256 - 1;
    address public router;
    address public myToken;
    address public weth;

    constructor(
        address _router,
        address _token,
        address _weth
    ) public {
        router = _router;
        myToken = _token;
        weth = _weth;
        IERC20(myToken).approve(router, UINT256_MAX);
    }

    function AddLiquidity(uint256 _amountTokenDesired) public payable {
        IERC20(myToken).transferFrom(msg.sender, address(this), _amountTokenDesired);
        IUniswapV2Router(router).addLiquidityETH{value: msg.value}(
            myToken,
            _amountTokenDesired,
            0,
            0,
            msg.sender,
            block.timestamp
        );
    }

    function buyToken() public payable {
        address[] memory path = new address[](2);
        path[0] = weth;
        path[1] = myToken;
        IUniswapV2Router(router).swapExactETHForTokens{
        value: msg.value
        }(0, path, msg.sender, block.timestamp);
    }
}