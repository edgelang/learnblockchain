pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Vault {
    mapping(address => uint) public deposited;
    address public immutable token;

    event Deposit(address addr,uint256 amount);
    event Withdraw(address addr,uint256 amount);

    constructor(address _token) {
        token = _token;
    }


    function deposit(uint amount) public {
        require(IERC20(token).transferFrom(msg.sender, address(this), amount), "Transfer from error");
        deposited[msg.sender] += amount;

        emit Deposit(msg.sender, amount);
    }

    function withdrawAll() public {
        uint256 amount = deposited[msg.sender];
        _withdraw(amount);
    }

    function withdraw(uint256 amount) public {
        _withdraw(amount);
    }

    function _withdraw(uint256 amount) internal {
        require(deposited[msg.sender] >= amount, "Insufficient amount");
        deposited[msg.sender] = deposited[msg.sender] - amount;

        IERC20(token).transfer(msg.sender, amount);

        emit Withdraw(msg.sender, amount);
    }
}

