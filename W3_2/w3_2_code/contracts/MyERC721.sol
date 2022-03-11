pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyERC721 is ERC721, Ownable {

    constructor() ERC721("My ERC721 Token", "MEC") {
    }

    function mint(address to, uint256 tokenId) public onlyOwner {
        _safeMint(to, tokenId, "");
    }

}