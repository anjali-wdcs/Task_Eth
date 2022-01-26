// SPDX-License-Identifier: MIT
pragma solidity ^0.7.1;


contract CONCATE {
    
    function concatenation(string memory str1, string memory str2) public pure returns (string memory) {
        return string(abi.encodePacked(str1, str2));
    }
}
