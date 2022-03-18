// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {

    constructor() ERC20("My Token", "MT") public {
        uint256 totalTokens = 100000000 * 10**uint256(decimals());
        _mint(msg.sender, totalTokens);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

}