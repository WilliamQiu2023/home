// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {CommLib} from "./CommLib.sol";

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
contract ChinaDAO{
   using CommLib for address;
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
    string _name;
    string  _willing;
    string  _principle;
    string _description;
    string _favour;

    struct Ask{
        uint64 id;
        address account;
        string description;
        bool status; // handled or not
        uint8 stage; // 0, initial, 1: passed, 2：not passed
        string reason;
    }
    mapping (uint64 => Ask) _asks;
    mapping(address=>uint64) _userAsk;
    uint64[] _waitings;
    uint64[] _approveds;
    uint64[] _rejecteds;
    uint64 seq;

    constructor(){
        _name = unicode"中国去中心化自治组织发展促进协会";
        _willing = unicode"促进中文社区的自治化组织发展";
        _principle = unicode"平等，爱，互助";
        _description = unicode"此协会本身为DAO(去中心化自治组织)，无官方属性";
       
        _favour = unicode"本合约账户接受捐赠并转赠给需要帮助的个体及组织";
    
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
    function addAdmin(address user,string memory adminName) public onlyAdmin{
        require(!user.isZero() || adminName.length()<20, "param error");
        require(_committee.length<=11,"member limit");
        _addAdmin = new Proposal(newId(),user,adminName,block.timestamp,msg.sender);
        emit logAddingProposal("addAdmin,id:",user, _addAdmin.id());
      
    }
    event logAddingProposal(string,address,uint);
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
            emit logApproveAdmin("passed,id:",_addAdmin.id(),true);
            _addAdmin.clear();
        }
          if (_addAdmin.reject()*2 > total){
                     _addAdmin.clear();
              emit logApproveAdmin("not passed,id",_addAdmin.id(), false);
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
        emit logProposal(string.concat("addProposal:",content,".id:"), proposal.id());
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

    function getDeclaration() public view returns (string memory){
        string memory result = string.concat(name(),";\n",willing(),";",principle(),";",description());
        return result;
    }

    function name() internal view returns (string memory){
        return string.concat(unicode"名称: ", _name);
    }

        function willing() internal view returns (string memory){
        return string.concat(unicode"愿景: ", _willing);
    }

        function principle() internal view returns (string memory){
        return string.concat(unicode"原则: ", _principle);
    }

            function description() internal view returns (string memory){
        return string.concat(unicode"介绍: ", _description);
    }

    // mapping (address=>uint64) _donates;


    event logDonate(string,address,uint);
    function donate(string memory _message) public payable  returns (string memory){
        require(msg.value>0,"money needed");
        // uint64 id = newId();
        // _donates[msg.sender] = id;
        emit logDonate(string.concat("thanks donate! message:",_message),msg.sender, msg.value);
        
        return "Thanks!!";
    }

    function getDonateDesc() public view returns (string memory){
        return _favour;
    }

    event logHelp(string a, uint b, uint c);

    function save(Ask memory ask) internal  {
        _asks[ask.id] = ask;
    }

    function getByUser(address addr) internal view  returns (Ask storage) {
                return _asks[_userAsk[addr]];
    }

    function askForHelp(string memory desc) public returns (string memory){
        require( _userAsk[msg.sender] <= 0, "repeated");
        Ask memory ask = Ask(newId(), msg.sender, desc, false, 0, "");
        save(ask);
        _userAsk[msg.sender] = ask.id;
        _waitings.push(ask.id);
          emit logHelp(string.concat("add Help",desc),ask.id,0);
        return "OK";
    }
    function queryHelp() public view returns (Ask memory){
        return getByUser(msg.sender);
    }

    function approveHelp(address payable  target, uint256 value) public hasAuth{
        Ask storage ask = getByUser(target);
        require(ask.account != address(0), "arg error");
        ask.status = true;
        ask.stage = 1;
        etrade(target, value);
        _approveds.push(ask.id);
        delete _waitings[ask.id];
        emit logHelp("approve Help:",ask.id,value);
    }
    function rejectHelp(address target, string calldata reason) public onlyAdmin{
        Ask storage ask = getByUser(target);
        require(!ask.account.isZero(), "arg error");
        ask.status = true;
        ask.reason = reason;
        ask.stage = 2;
        _rejecteds.push(ask.id);
        delete _waitings[ask.id];
        emit logHelp(string.concat("reject Help, reason:",reason), ask.id, 0);
    }

    function helps() public view returns (uint64[] memory){
        return _waitings;
    }

    function askById(uint64 id) public view returns (address,bool,uint8,string memory){
        Ask memory e = _asks[id];
        return  (e.account,e.status,e.stage,e.description);
    }


    event logEtrade(string,address,uint);
    function etrade(address payable  t, uint256 value) internal hasAuth  {
        require(address(this).balance >= value, "bal lmt" );
        t.transfer(value);
         emit logEtrade("etracd result:",t,value);
    }

    function introduction() public view  returns (string memory){
   
        return string.concat(getDeclaration(),";",getDonateDesc());
    }

    function newId() internal  returns (uint64){
         seq++;
         return seq;
    }
}