// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

abstract contract AccessControl{
    modifier onlyAdmin(){
        CheckAdmin(getCommittee(), msg.sender);
        _;
    }
    function getCommittee() public virtual returns (address[] memory);

    function CheckAdmin(address[] memory admins, address current) public pure  returns (bool){
        for (uint256 i=0; i< admins.length; i++) 
        {
            if (admins[i] == current){
                return true;
            }
        }
        return false;
    }
}