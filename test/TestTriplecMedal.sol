// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "../contracts/medal/TriplecMedal.sol";
import "../library/EIP712.sol";

contract TestTriplecMedal is EIP712{
    // TriplecMedal public triplecMedal;

    // function beforeEach() public{
    //     triplecMedal = new TriplecMedal("","");
    // }


    function testClaim() public{
        bytes memory h = 
            abi.encode(
                keccak256(
                    "Claim(uint256 pid,uint256 dummyId,uint256 level,address mintTo,bool canTranster)"
                ),
                1,
                1,
                1,
                0x3E7eD6a40b88da2A99292bFb856451E145d69747,
                false
            );
        require(false,string(h));
    }

    function bytes32ToString(bytes32 _bytes32) internal pure returns (string memory){
        bytes memory bytesArray = bytes32ToBytes(_bytes32);
        return string(bytesArray);
    }

    function bytes32ToBytes(bytes32 _bytes32) internal pure returns (bytes memory){
        // string memory str = string(_bytes32);
        // TypeError: Explicit type conversion not allowed from "bytes32" to "string storage pointer"
        bytes memory bytesArray = new bytes(32);
        for (uint256 i; i < 32; i++) {
            bytesArray[i] = _bytes32[i];
        }
        return bytesArray;
    }
}


