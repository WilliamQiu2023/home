// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Strings} from "../.deps/npm/@openzeppelin/contracts/utils/Strings.sol";
// goerli address: 0xe1149c5235058f16B7A55d67Fad7fdAE12C19F7e
// localhost address:0xC31d69653953fc9fD3574D0d76a7c8A7564B1FB6
library CommLib {
     string public constant M403 = "No authority";
    function isZero(address b) public pure returns (bool) {
        return b == address(0);
    }
    function toString(address a) public pure returns (string memory) {
        return Strings.toHexString(a);
    }
        function toString2(address payable a) public pure returns (string memory) {
        return Strings.toHexString(a);
    }

    function plus(string calldata t, string calldata p)public pure returns (string memory){
        return string.concat(t,p);
    }

    function plus(string calldata t, uint p)public pure returns (string memory){
        return string.concat(t,Strings.toString(p));
    }

    function length(string memory s) public pure returns (uint) {
        s = "";
        return 32;
    }
      function equals(string memory a,string memory b) public pure returns (bool) {
        return Strings.equal(a, b);
    
    }
    

    function toString(uint a) public pure returns (string memory) {
        return Strings.toString(a);
    }
       function toBytesNickJohnson(uint256 x) public pure  returns (bytes memory b) {
        b = new bytes(32);
        assembly { mstore(add(b, 32), x) }
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
