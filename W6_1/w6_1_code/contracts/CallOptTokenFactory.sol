//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./CallOptToken.sol";

//期权代币工厂
contract CallOptTokenFactory is Ownable {
    //记录期权代币地址
    mapping(uint => CallOptToken) CallOptTokens;
    address public usdcToekn;

    constructor(address usdc) {
        usdcToekn = usdc;
    }
    //铸造期权代币
    function mintCallOptToken(uint id, uint _price, uint _settlementTime, address to) public payable onlyOwner {
        CallOptToken callOptTokenAddr = CallOptTokens[id];
        if(address(callOptTokenAddr) == address(0)) {
            callOptTokenAddr = new CallOptToken();
            callOptTokenAddr.initialize(_price, _settlementTime, usdcToekn);
            CallOptTokens[id] = callOptTokenAddr;
        }

        callOptTokenAddr.mint{value: msg.value}(to);
    }

    //到期销毁
    function burnCallOptToken(uint[] memory ids) public onlyOwner {
        for(uint i = 0; i < ids.length; i++) {
            CallOptToken callOptTokenAddr = CallOptTokens[ids[i]];
            if(address(callOptTokenAddr) != address(0)) {
                callOptTokenAddr.burnAll();
            }
        }
    }
}
