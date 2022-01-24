// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Map {
    mapping(address => string) public map;

    function add(address userAddress, string memory name) public{
        map[userAddress] = name;
    }
}
