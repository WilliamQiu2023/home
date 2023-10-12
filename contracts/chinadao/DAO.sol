// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Declaration.sol";
import "./Proposals.sol";
import "./authority/AccessControl.sol";
contract DAO is Declaration,AccessControl,Proposals{

    // ten person group the committee
    address[] private  committee = new address[](10); 

    constructor(){
        committee[0] = msg.sender;
    }

    function getCommittee() public override view returns (address[] memory){
        return committee;
    }
    function addCommitteer(address one) internal {
        require(committee.length<=10,"committee.length can't greater than 10");
        committee[committee.length] = (one);
    }

    function commitProposal(string calldata content) public {
        super.commitProposal(address(0), content);
    }

        string tip;

    function primsg(string calldata param) public  returns (string memory){
        tip = param ;
        string memory result = string.concat(tip , "hola");
        return result;
    }
}