
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Logs{

    event log(string s);
    event log(uint i);
    event log(address i);
    event log(string a,address b, uint c, uint32);
    
}