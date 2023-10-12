// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./Events.sol";
interface Proposal {
    function getId()external  returns (uint32);
    function getReject() external  returns (uint8);
    function getSupport() external  returns (uint8);
       function support() external;
       function reject() external;
    function getTime() external  returns (uint256);
    function getAuthor() external  returns (address);
    
}
contract AddingAdmin is Proposal{

    uint32 id;
    address applicant;
    string name;
    uint8 _reject;
    uint8 _support;
    uint256 time;
    address auth;
    constructor(uint32 _a, address _b,string memory _c,uint256 _d, address _e){
        id = _a;
        applicant = _b;
        time = _d;
        auth = _e;
        name = _c;
    }
    function clear() external  {
        id = 0;
        applicant = address(0);
        time = 0;
        auth = address(0);
        name = "";
    }
    function getId()external view  returns (uint32){
        return id;
    }
    function getReject() external view returns (uint8){
        return _reject;
    }
    function getSupport() external view returns (uint8){
        return  _support;
    }
    function getTime() external view returns (uint256){
        return time;
    }
    function support() external {
        _support ++;
    }
    function reject() external {
        _reject ++;
    }
        function getApplicant() external view returns (address){
        return applicant;
    }
    function getAuthor() external view returns (address){
        return auth;
    }
}
abstract contract Administrate is Events{
   
    struct Admin{
        address account;
        string name;
    }

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
    address auth;
    Admin[] committee;
    AddingAdmin addAdmin;
    
    mapping (uint32 => AddingAddminVote) addingAddminVoteTable;
    mapping (address => AddingAddminVoter) adminVoteMapping;

    mapping (uint32 => Proposal) proposalTable;
    mapping(address=>UserProposal) userProposalMap;

    uint32[] waitingList;
    uint32[] approvedList;
    uint32[] rejectedList;

    modifier onlyAuth(){
        require(auth == msg.sender,"You has no authority");
        _;
    }
    modifier onlyAdmin(){
        bool hasAuth = false;
        for (uint256 i=0; i< committee.length; i++) 
        {
            Admin memory admin = committee[i];
            if (msg.sender == admin.account){
                hasAuth = true;
                break ;
            }
        }
        require(hasAuth,"You has no authority");
        _;
    }
    constructor(){
        auth = msg.sender;
        Admin memory admin = Admin({account:auth, name:"Author"});
        committee.push(admin);
    }
    function newId() internal virtual returns (uint32);
    function getCommittee() internal view  returns (Admin[] memory){
        return committee;
    }

    function cmitAddAdmin(address user,string calldata _name) public onlyAdmin{
        require(committee.length<=11,"the num of committee must less than 10");
        addAdmin = new AddingAdmin(newId(),user,_name,block.timestamp,msg.sender);
      
    }

    function existAdmin(address admin) internal view returns (bool){
        require(admin != address(0),"param admin is not elegal");
        if (admin == address(0)){
            return false;
        }
        for (uint i=0; i< committee.length; i++) 
        {
            if (admin == committee[i].account){
                return true;
            }
        }
        return false;
    }
    function approveAddAdminProposal( bool pass) public onlyAdmin{
        AddingAdmin proposal = addAdmin;
        require(!existAdmin(proposal.getApplicant()),"It has passed!");
        
        // check wether has approved
        AddingAddminVoter storage aavoter = adminVoteMapping[msg.sender];
        if (aavoter.voter == address(0)){
            //emit log("current user not vote any before");
            aavoter.voter = msg.sender;
            AddingAddminVote memory vote = AddingAddminVote(newId(),proposal.getId(),msg.sender,pass);
            addingAddminVoteTable[vote.id] = vote;
            aavoter.ids.push(vote.id);
        }else {
            bool voted = false;
             for(uint256 i=0; i< aavoter.ids.length; i++){
                  AddingAddminVote storage vote = addingAddminVoteTable[aavoter.ids[i]];
                  if (vote.proposalId == proposal.getId()){
                    // already voted;
                    voted = true;
                    break ;
                  }
             }
             require(voted == false, "current user voted before");
             if (!voted){
             //      emit log("current user not vote before");
                  AddingAddminVote memory vote = AddingAddminVote(newId(),proposal.getId(),msg.sender,pass);
                 addingAddminVoteTable[vote.id] = vote;
                 aavoter.ids.push(vote.id);
             }
        }
        if (pass){
            proposal.support();
        }else {
            proposal.reject();
        }
        uint total = committee.length;
        if (proposal.getSupport()*2 >= total){
            Admin memory admin = Admin({account: proposal.getApplicant(), name:""});
            committee.push(admin);
            proposal.clear();
              emit log("passed,clear done");
        }
          if (proposal.getReject()*2 > total){
                     proposal.clear();
              emit log("not passed, clear done");
          }
    }

    function getAdminProposal() public view  returns (AddingAdmin){
        return addAdmin;
    }

    function commitProposal(Proposal proposal) internal virtual{
        proposalTable[proposal.getId()] = proposal;
        UserProposal storage userProposal =  userProposalMap[proposal.getAuthor()] ;
        userProposal.auth = proposal.getAuthor();
        uint32[] storage ids = userProposal.proposalIds;
        ids.push(proposal.getId());
        waitingList.push(proposal.getId());
    }
     function approveProposal(Proposal proposal, bool support) internal virtual{
         if (support){
             approvedList.push(proposal.getId());
         }else {
             rejectedList.push(proposal.getId());
         }
         delete waitingList[proposal.getId()];
     }
       function getProposal(uint32 id) public view returns (Proposal){
         return proposalTable[id];
     }
     function getWaitingProposalList() public view returns (uint32[] memory){
         return waitingList;
     }

}