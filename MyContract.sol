// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// sending ether to a smart contract

contract MyContract {
    
    function acceptEther() external payable {
    }

    function balanceof() external view returns(uint){
        return address(this).balance;
    }
}
