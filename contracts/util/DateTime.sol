// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
/**
 * @dev Collection of functions related to the Time type
 */
library DateTime{
    struct Time{
        uint256 time; 
    }

    function Now()public view returns (Time memory t){
        t.time = block.timestamp;
    }
    function Now(Time memory t) public view  returns (Time memory){
        t.time = block.timestamp;
        return t;
    }

    function getTime(Time memory t) public pure  returns (uint256){
        return t.time;
    }

    function setTime(Time memory t, uint256 n) public pure{
        t.time = n;
    }
}