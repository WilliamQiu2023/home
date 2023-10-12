// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./Events.sol";
import "./authority/AccessControl.sol";
import {Addresses,Admins,Admin,StringLib} from "../util/CommLib.sol";
interface Proposal {
    function id()external  returns (uint32);
    function reject() external  returns (uint8);
    function support() external  returns (uint8);
    function vote(bool s) external;
    function time() external  returns (uint256);
    function author() external  returns (address);
    
}
contract AddingAdmin is Proposal{

    uint32 _id;
    address _applicant;
    string _name;
    uint8 _reject;
    uint8 _support;
    uint256 _time;
    address _auth;
    constructor(uint32 _a, address _b,string memory _c,uint256 _d, address _e){
        _id = _a;
        _applicant = _b;
        _time = _d;
        _auth = _e;
        _name = _c;
    }
    function clear() external  {
        _id = 0;
        _applicant = address(0);
        _time = 0;
        _auth = address(0);
        _name = "";
    }
    function id()external view  returns (uint32){
        return _id;
    }
    function reject() external view returns (uint8){
        return _reject;
    }
    function support() external view returns (uint8){
        return  _support;
    }
    function time() external view returns (uint256){
        return _time;
    }
    function vote(bool f) external {
        if (f) {
             _support ++;   
        } else {
            _reject ++;
        }
        
    }
    function applicant() external view returns (address){
        return _applicant;
    }
    function author() external view returns (address){
        return _auth;
    }
}
abstract contract Administrate is Logs,Authority{
   using Addresses for address;
   using Admins for Admin;
   using StringLib for string;
    // struct Admin{
    //     address account;
    //     string name;
    // }

    struct UserProposal{
        address auth;
        uint32[] proposalIds;
    }
    struct AddingAddminVote{
        uint32 id;
        uint32 proposalId;
        address voter;
        bool support ;
    }
    struct AddingAddminVoter{
        uint32[] ids;
        address voter;
    }
    address _auth;
    Admin[] _committee;
    AddingAdmin _addAdmin;
    
    mapping (uint32 => AddingAddminVote) addingAddminVoteTable;
    mapping (address => AddingAddminVoter) adminVoteMapping;

    mapping (uint32 => Proposal) proposalTable;
    mapping(address=>UserProposal) userProposalMap;

    uint32[] waitingList;
    uint32[] approvedList;
    uint32[] rejectedList;

    constructor(){
        _auth = msg.sender;
        Admin memory admin = Admin(_auth, "Author");
        _committee.push(admin);
    }
    function z0Addr() internal pure returns (address) {
        return address(0);
    }
   
    function committee() internal override view  returns (address[] memory){
        address[] memory _admins = new address[](_committee.length);
        for (uint i; i < _committee.length; i++) 
        {
            _admins[i] = _committee[i].addrezz;
        }
        return _admins;
    }
    function admins() internal view  returns (Admin[] memory){
        return _committee;
    }
    function addAdmin(address user,string calldata _name) public onlyAdmin{
        require(!user.isZero() || _name.length()<20, "param error");
        require(_committee.length<=11,"the num of committee must less than 10");
        _addAdmin = new AddingAdmin(newId(),user,_name,block.timestamp,msg.sender);
      
    }

    function existAdmin(address admin) internal view returns (bool){
        require(!admin.isZero(),"can't be 0 addr");

        for (uint i=0; i< _committee.length; i++) 
        {
            if (admin == _committee[i].addrezz){
                return true;
            }
        }
        return false;
    }
    function approveProp( bool pass) public onlyAdmin{
        AddingAdmin proposal = _addAdmin;
        require(!existAdmin(proposal.applicant()),"It's passed");
        
        // check wether has approved
        AddingAddminVoter storage aavoter = adminVoteMapping[msg.sender];
        if (aavoter.voter.isZero()){
            
            aavoter.voter = msg.sender;
            AddingAddminVote memory vote = AddingAddminVote(newId(),proposal.id(),msg.sender,pass);
            addingAddminVoteTable[vote.id] = vote;
            aavoter.ids.push(vote.id);
        }else {
            bool voted = false;
             for(uint256 i=0; i< aavoter.ids.length; i++){
                  AddingAddminVote storage vote = addingAddminVoteTable[aavoter.ids[i]];
                  if (vote.proposalId == proposal.id()){
                    // already voted;
                    voted = true;
                    break ;
                  }
             }
             require(voted == false, "repeated voted");
             if (!voted){
             //      emit log("current user not vote before");
                  AddingAddminVote memory vote = AddingAddminVote(newId(),proposal.id(),msg.sender,pass);
                 addingAddminVoteTable[vote.id] = vote;
                 aavoter.ids.push(vote.id);
             }
        }
        if (pass){
            proposal.support();
        }else {
            proposal.reject();
        }
        uint total = _committee.length;
        if (proposal.support()*2 >= total){
            Admin memory admin = Admin(proposal.applicant(),"");
            _committee.push(admin);
            proposal.clear();
              emit log("passed,clear done");
        }
          if (proposal.reject()*2 > total){
                     proposal.clear();
              emit log("not passed, clear done");
          }
    }

    function getAdminProposal() public view  returns (AddingAdmin){
        return _addAdmin;
    }

    function commitProposal(Proposal proposal) internal virtual{
        proposalTable[proposal.id()] = proposal;
        UserProposal storage userProposal =  userProposalMap[proposal.author()] ;
        userProposal.auth = proposal.author();
        uint32[] storage ids = userProposal.proposalIds;
        ids.push(proposal.id());
        waitingList.push(proposal.id());
    }
     function approveProposal(Proposal proposal, bool support) internal virtual{
         if (support){
             approvedList.push(proposal.id());
         }else {
             rejectedList.push(proposal.id());
         }
         delete waitingList[proposal.id()];
     }
       function getProposal(uint32 id) public view returns (Proposal){
         return proposalTable[id];
     }
     function getWaitingProposalList() public view returns (uint32[] memory){
         return waitingList;
     }

}