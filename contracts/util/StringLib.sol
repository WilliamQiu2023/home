// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Strings} from "../../.deps/npm/@openzeppelin/contracts/utils/Strings.sol";

library Addresses {
    function isZero(address b) public pure returns (bool) {
        return b == address(0);
    }
    function toString(address a) public pure returns (string memory) {
        return Strings.toHexString(a);
    }
}
struct Admin {
        address addrezz;
        string name;
}
library Admins {
    function newAdmin(address addr, string calldata name) public pure returns (Admin memory) {
        Admin memory _admin = Admin(addr,name);
        return _admin;
    }
}
library StringLib{
   
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
}