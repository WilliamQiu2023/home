// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

struct Vote{
    uint32 id;
}

library StringLib{

    function plus(string calldata t, string calldata p)public pure returns (string memory){
        return string.concat(t,p);
    }

    function plus(string calldata t, uint p)public pure returns (string memory){
        return string.concat(t,"");
    }

    function equals(string memory t, string memory p) public pure returns (bool){
        bytes32 a = keccak256(abi.encode(t));
        bytes32 b = keccak256(abi.encode(p));
        return a == b;
    }
}