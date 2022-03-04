// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IScore {
    function setScore(address _student, uint256 _score) external;
}

contract Teacher {
    address public owner;

    modifier onlyOwner {
        require(msg.sender == owner, "owner only");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function setScore(IScore _iscore, address _student, uint256 _score) external onlyOwner {
        IScore(_iscore).setScore(_student, _score);
    }
}