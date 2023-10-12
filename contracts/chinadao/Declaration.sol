// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./util/DateTime.sol";

contract Declaration {
    using DateTime for DateTime.Time;
    string  _declaration;
    string  _vision;
    string  _principle;
    DateTime.Time createTime;
    constructor(){
        _declaration = "We construct Home DAO now.";
        _vision = "To make a better virtual world that likes our home for all human beings .";
        _principle = "equality, love, willing";
        createTime = DateTime.Now();
    }

    function getDeclaration() public view returns (string memory){

        return _declaration;
    }

        function getVision() public view returns (string memory){

        return _vision;
    }
        function getPrinciple() public view returns (string memory){

        return _principle;
    }

    function getCreateTime() public view returns (DateTime.Time memory){
        return createTime;
    }
}