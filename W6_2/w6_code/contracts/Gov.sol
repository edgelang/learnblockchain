//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IMyComp {
    function getPriorVotes(address account, uint blockNumber) external view returns (uint96);
}

contract Gov is Ownable {

    uint256 public proposalCount;
    address public daoToken;
    mapping(uint256 => Proposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public userOption;
    uint256 public minSupportNum;

    modifier onlyWallet() {
        require(msg.sender == address(this));
        _;
    }

    struct Proposal {
        address destination; //交易地址
        uint256 value; //交易金额
        bytes data; //交易执行方法数据
        uint256 overTime; //投票截止时间
        bool executed; //是否执行
        uint256 support; //支持票数
        uint256 against; //反对票数
        string description; //提案详情
        uint blockNum; //投票区块数
    }

    constructor(address _dao, uint256 _minSupportNum) {
        daoToken = _dao;
        minSupportNum = _minSupportNum;
    }

    function createProposal(address _destination, uint256 _value, bytes memory _data, uint256 _overTime, string memory _description) external onlyOwner {
        require(_overTime > block.timestamp, "time error");
        uint256 proposalId = proposalCount;
        proposals[proposalId] = Proposal({
            destination: _destination,
            value: _value,
            data: _data,
            executed: false,
            overTime: _overTime,
            support: 0,
            against: 0,
            description: _description,
            blockNum: block.number
        });
        proposalCount += 1;
    }

    function voteProposal(uint256 _proposalId, bool _option) external {
        //防止用户重复投票
        require(userOption[msg.sender][_proposalId] != true, "The user has already voted");
        Proposal memory proposal = proposals[_proposalId];
        require(proposal.overTime > block.timestamp, "time error");
        uint256 voteNum = uint256(IMyComp(daoToken).getPriorVotes(msg.sender, proposal.blockNum));

        if(voteNum > 0) {
            if (_option) {
                proposals[_proposalId].support = proposals[_proposalId].support + voteNum;
            } else {
                proposals[_proposalId].against = proposals[_proposalId].against + voteNum;
            }
        }

        userOption[msg.sender][_proposalId] = true;
    }

    function executeProposal(uint256 _proposalId) external {
        Proposal storage proposal = proposals[_proposalId];
        require(proposal.overTime < block.timestamp, "time error");
        require(proposal.support > proposal.against, "Not enough support");
        require(proposal.support > minSupportNum, "Not enough support");

        proposal.executed = true;
        if (
            external_call(
                proposal.destination,
                proposal.value,
                proposal.data
            )
        ) {

        } else {
            proposal.executed = false;
        }
    }

    //修改最小提案执行票数
    function changeMinSupportNum(uint256 newMinSupportNum) public onlyWallet {
        minSupportNum = newMinSupportNum;
    }
    // call has been separated into its own function in order to take advantage
    // of the Solidity's code generator to produce a loop that copies tx.data into memory.
    function external_call(
        address destination,
        uint256 value,
        bytes memory data
    ) internal returns (bool) {
        bool result;
        assembly {
            result := call(500000, destination, value, add(data, 0x20), mload(data), 0, 0)
        }
        return result;
    }
}