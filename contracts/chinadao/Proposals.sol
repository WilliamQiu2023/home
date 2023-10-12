// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./Voters.sol";
/**
* Proposal manage
*/
contract Proposals{
    using Voters for *;
    mapping (address=> Voters.Proposal) userProposal;
    mapping (uint32=>Voters.Proposal) proposals;
    uint32 index ;

    uint256 temp;
    constructor(){
        temp = 100;
        index = 1;
    }
    function commitProposal(address author, string memory content) public returns (uint256) {
        Voters.Proposal memory proposal;
        proposal.id = index++;
        proposal.content = content;
        proposal.author = author;
        proposal.setTime();

        proposals[proposal.id] = proposal;

        return 0;
    }

    function approve(uint id, bool passed)public {

    }

    function getProposals() public view returns (uint32){
        return index;
    }

    function getTemp() public view returns (uint256){
        return temp;
    }
}