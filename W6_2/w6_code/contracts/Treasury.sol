//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Treasury is Ownable {
    using SafeERC20 for IERC20;

    address public daoToken;

    constructor(address _dao) {
        daoToken = _dao;
    }

    function withdraw(uint amount, address to) external onlyOwner {
        IERC20(daoToken).safeTransfer(to, amount);
    }
}