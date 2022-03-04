// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Score {
    mapping(address => uint256) public score;
    address public teacher;
    address public owner;

    modifier onlyTeacher {
        require(msg.sender == teacher, "teacher only");
        _;
    }

    event ModScore(address indexed student, uint256 score);

    modifier onlyOwner {
        require(msg.sender == owner, "owner only");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function setScore(address _student, uint256 _score) external onlyTeacher {
        require(_score <= 100, "_score too big");
        score[_student] = _score;

        emit ModScore(_student, _score);
    }

    function setTeacherAddr(address _teacher) external onlyOwner {
        teacher = _teacher;
    }
}