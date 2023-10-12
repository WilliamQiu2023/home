// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./Events.sol";
import "./Administrator.sol";
import {Addresses} from "../util/StringLib.sol";
import {ERC20} from "../../.deps/npm/@openzeppelin/contracts/token/ERC20/ERC20.sol";

abstract contract Stock is Administrate, ERC20{
   using Addresses for address;

    uint32 _votes;
    /**
    * 投票权，初始基金为100万，投票权为1：100，后续增发不超过1：10的投票权以保护创始团队的稳定性
    */

    mapping (address=>uint32) _aurhority;

    struct TxRightProposal{
        address to;
        uint32 value;
        uint time;
        uint32 support;
    }
    TxRightProposal txp;
    constructor() ERC20("CDAO Token","CDAO"){
        uint32 initCDAO = 10**6;
        _votes = initCDAO*100;
        _aurhority[msg.sender] = _votes;
        _mint(address(this), initCDAO);
    }

    function transferRight(address to, uint32 value) public {
        require(txp.to.isZero(),"waiting to be done");
        txp.to = to;
        txp.value = value;
        txp.time = block.timestamp;
    }

    function voteAuthority() public {
        uint32 rights = _aurhority[msg.sender];
        require(rights>0,"You have no right for vote");
        txp.support += rights;
        if (txp.support > _votes/2){
            _aurhority[txp.to] += txp.value;
            emit log("vote right changed");
        }
        
    }
}