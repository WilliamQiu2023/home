//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TestContr {
    constructor() {
        
    }

    function getText() public pure returns (string memory) {
        return "123aaaa";
    }

    function f2() public pure returns (uint) {
        return 1;
    }
    
}

struct Student {
    string name;
}