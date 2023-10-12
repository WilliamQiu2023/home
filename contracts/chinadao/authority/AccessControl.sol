// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

abstract contract Authority{
    address author;
    string constant public  M403 = "No authority";
    constructor(){
        author = msg.sender;
    }

    modifier hasAuth(){
        require(msg.sender == author,M403);
        _;
    }
    modifier isAuth(){
        require(msg.sender == author,M403);
        _;
    }
    modifier onlyAdmin(){
        require(isAdmin(), M403);
        _;
    }
    function newId() internal virtual returns (uint32);
    function committee() internal  virtual returns (address[] memory);

    function isAdmin() public returns (bool) {
        return check(msg.sender);
    }
    function check(address addr) public returns (bool){
        for (uint256 i=0; i< committee().length; i++) 
        {
            if (committee()[i] == addr){
                return true;
            }
        }
        return false;
    }
}