// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "../util/DateTime.sol";

library Voters{
    using DateTime for DateTime.Time;
    struct Vote{
        address auth;
        bool approve;
    }

    struct Proposal{
        uint32 id;
        string content;
        address author;
        DateTime.Time createTime;
        DateTime.Time terminalTime;
        bool status;
    }

    struct User{
        address account;
        uint64 balance;
        uint16 voteWeights;
    }
/*
    struct UserProposals{
        uint32 id0;
        uint32 id1;
        uint32 id2;
    }
*/
    function setTime(Proposal memory p) public view  {
        p.createTime = DateTime.Now();
        p.terminalTime.setTime(block.timestamp + 2000000);
    }
}