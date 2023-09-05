pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT

pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface ITriplecMedal is IERC721 {
      
    struct Pinfo {
        uint256 pid;
        uint256 level; 
        address master;
        bool canTranster;
    }

    function mint(
        address to, 
        Pinfo calldata pinfo) external returns(uint256);

    function getPinfo(uint256 tokenId) 
        external 
        view 
        returns (Pinfo memory pinfo);

}
