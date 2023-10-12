// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./Administrator.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

abstract contract Stock is Administrate, ERC20{


    uint32 totalRights;
    /**
    * 投票权，初始基金为100万，投票权为1：100，后续增发不超过1：10的投票权以保护创始团队的稳定性
    */

    mapping (address=>uint32) userRightMap;

    struct TxRightProposal{
        address to;
        uint32 value;
        uint time;
        uint32 support;
    }
    TxRightProposal txp;
    constructor() ERC20("CDAO Token","CDAO"){
        uint32 initCDAO = 10**6;
        totalRights = initCDAO*100;
        userRightMap[msg.sender] = totalRights;
        _mint(address(this), initCDAO);
    }

    function transferRight(address to, uint32 value) public {
        require(txp.to == address(0),"exists one, you have to wait for the last tx done");
        txp.to = to;
        txp.value = value;
        txp.time = block.timestamp;
    }

    function voteForTransferRight() public {
        uint32 rights = userRightMap[msg.sender];
        require(rights>0,"You have no right for vote");
        txp.support += rights;
        if (txp.support > totalRights/2){
            userRightMap[txp.to] += txp.value;
            emit log("vote right changed");
        }
        
    }
}