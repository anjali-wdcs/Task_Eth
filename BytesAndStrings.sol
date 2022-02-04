pragma solidity ^0.4.19;

contract BytesOrStrings {
  string constant _string = "My Work!";
  bytes32 constant _bytes = "My Universe";

  function  changedToString() public pure returns(string) {
    return _string;
  }

  function  changedToBytes() public pure returns(bytes32) {
    return _bytes;
  }
}
