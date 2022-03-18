// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

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

interface IMasterChef {
    struct UserInfo {
        uint256 amount; // How many LP tokens the user has provided.
        uint256 rewardDebt; // Reward debt. See explanation below.
    }
    function deposit(uint256 pid, uint256 amount) external;
    function withdraw(uint256 pid, uint256 amount) external;

    function userInfo(uint256 pid, address pool) external returns (UserInfo memory userInfo);
}

contract MyTokenMarket {
    using SafeERC20 for IERC20;

    uint256 private constant UINT256_MAX = 2**256 - 1;
    address public router;
    address public myToken;
    address public weth;
    address public masterChef;

    struct UserInfo {
        uint256 amount; // How many LP tokens the user has provided.
        uint256 rewardDebt; // Reward debt. See explanation below.
    }

    constructor(
        address _router,
        address _token,
        address _weth,
        address _masterChef
    ) public {
        router = _router;
        myToken = _token;
        weth = _weth;
        masterChef = _masterChef;
        IERC20(myToken).safeApprove(router, UINT256_MAX);
        IERC20(myToken).safeApprove(masterChef, UINT256_MAX);
    }

    function AddLiquidity(uint256 _amountTokenDesired) public payable {
        IERC20(myToken).safeTransferFrom(msg.sender, address(this), _amountTokenDesired);
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
        }(0, path, address(this), block.timestamp);

        uint256 depositAmount = IERC20(myToken).balanceOf(address(this));
        IMasterChef(masterChef).deposit(0, depositAmount);
    }

    function withdraw() public {
        IMasterChef.UserInfo memory userInfo = IMasterChef(masterChef).userInfo(0, address(this));
        uint256 withdrawAmount = userInfo.amount;
        IMasterChef(masterChef).withdraw(0, withdrawAmount);
    }
}