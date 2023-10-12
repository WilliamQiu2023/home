// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library converter{
        function toBytesNickJohnson(uint256 x) public pure  returns (bytes memory b) {
        b = new bytes(32);
        assembly { mstore(add(b, 32), x) }
    }

    function toString(uint playChoice) public pure returns (string memory s) {
        bytes memory c = toBytesNicolasMassart(playChoice);
        return string(c);
    }
    
    function toBytesEth(uint256 x) public pure returns (bytes memory b) {
        b = new bytes(32);
        for (uint i = 0; i < 32; i++) {
            b[i] =  bytes1(uint8(x / (2**(8*(31 - i))))); 
        }
        return b;
    }

    function toBytesNicolasMassart(uint256 x) public pure returns (bytes memory c) {
        bytes32 b = bytes32(x);
        c = new bytes(32);
        for (uint i=0; i < 32; i++) {
            c[i] = b[i];
        }
    }
}