// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {CommLib} from "../util/CommLib.sol";
import {Strings} from "../../.deps/npm/@openzeppelin/contracts/utils/Strings.sol";

// add admin Proposal
contract Proposal{

    uint64 _id;
    address _applicant;
    string _name;
    uint8 _reject;
    uint8 _support;
    uint256 _time;
    address _auth;
    constructor(uint64 _a, address _b,string memory _c,uint256 _d, address _e){
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
    function id()external view  returns (uint64){
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
abstract contract Administrate{
   using CommLib for address;
   using CommLib for Admin;
   using CommLib for string;
   using CommLib for uint;
    struct Admin {
            address addrezz;
            string name;
    }
    string constant public  M403 = "No authority";
 
    address _author;
    Admin[] _committee;
    Proposal _addAdmin;
    

    mapping (address => bool) _voted;
    mapping (uint64 => Proposal) _proposals;
    uint64[] _waiting;

    constructor(){
        _author = msg.sender;
        Admin memory admin = Admin(_author, "Author");
        _committee.push(admin);
    }


    modifier hasAuth(){
        require(msg.sender == _author,M403);
        _;
    }
    modifier isAuth(){
        require(msg.sender == _author,M403);
        _;
    }
    modifier onlyAdmin(){
        require(isAdmin(), M403);
        _;
    }
    function newId() internal virtual returns (uint64);

    function isAdmin() internal view returns (bool) {
        return isAdmin(msg.sender);
    }
    function isAdmin(address addr) internal view returns (bool){
        for (uint256 i=0; i< committee().length; i++) 
        {
            if (committee()[i] == addr){
                return true;
            }
        }
        return false;
    }
   
    function committee() public view  returns (address[] memory){
        address[] memory _admins = new address[](_committee.length);
        for (uint i; i < _committee.length; i++) 
        {
            _admins[i] = _committee[i].addrezz;
        }
        return _admins;
    }
    function admins() internal    view  returns (Admin[] memory){
        return _committee;
    }
    function addAdmin(address user,string calldata _name) public onlyAdmin{
        require(!user.isZero() || _name.length()<20, "param error");
        require(_committee.length<=11,"member limit");
        _addAdmin = new Proposal(newId(),user,_name,block.timestamp,msg.sender);
        emit logAddingProposal("addAdmin,id:", _addAdmin.id());
      
    }
    event logAddingProposal(string,uint);
    function existAdmin(address admin) internal view returns (bool){
        require(!admin.isZero(),"address(0)");

        for (uint i=0; i< _committee.length; i++) 
        {
            if (admin == _committee[i].addrezz){
                return true;
            }
        }
        return false;
    }
    function approveAdmin( bool pass) public onlyAdmin{
        require(!existAdmin(_addAdmin.applicant()),"It's passed");
        
        // check  repeat do
        bool voted = _voted[msg.sender];
        require(!voted, "repeat approve");
            
        _addAdmin.vote(pass);
      
        uint total = _committee.length;
        if (_addAdmin.support()*2 >= total){
            Admin memory admin = Admin(_addAdmin.applicant(),"");
            _committee.push(admin);
            emit logApproveAdmin("passed,address:",_addAdmin.id(),true);
            _addAdmin.clear();
        }
          if (_addAdmin.reject()*2 > total){
                     _addAdmin.clear();
              emit logApproveAdmin("not passed,",_addAdmin.id(), false);
          }
    }
    event logApproveAdmin(string,uint,bool);
    function getAddAdmin() public view  returns (Proposal){
      
        return _addAdmin;
    }
    event logProposal(string,uint);
    function addProposal(string memory content) public onlyAdmin{
        Proposal proposal = new Proposal(newId(),address(0),content,block.timestamp,msg.sender);
        _proposals[proposal.id()] = proposal;
        _waiting.push(proposal.id());
        emit logProposal("addProposal,id:", proposal.id());
    }
     function approveProposal(uint32 id, bool support) public onlyAdmin{
          emit logProposal("hProposal,id:", id);
        Proposal proposal = _proposals[id];
        require(proposal.id()>0, "Not exist");
        proposal.vote(support);
        uint total = _committee.length;
        if (proposal.support()*2 >= total){
             delete _waiting[proposal.id()];
             emit logProposal("passed Proposal,id:", proposal.id());
        }
      
     }
       function getProposal(uint32 id) public view returns (Proposal){
         return _proposals[id];
     }

     function proposals() public view returns (uint64[] memory){
         return _waiting;
     }

}