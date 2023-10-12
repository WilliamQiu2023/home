// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "../util/converter.sol";
import "./Stock.sol";
import "./Administrator.sol";
import "./authority/AccessControl.sol";

abstract contract Declaration{
    string _name;
    string  willing;
    string  principle;
    string description;
    constructor(){
        _name = unicode"中国去中心化自治组织发展促进协会";
        willing = unicode"促进中文社区的自治化组织发展";
        principle = unicode"平等，爱，互助";
        description = unicode"此协会本身为DAO(去中心化自治组织)，无官方属性";
    }

    function getMessage() internal view returns (string memory){
        string memory result = string.concat(getName(),";\n");
        result = string.concat(result, getWilling());
         result = string.concat(result, ";\n");
        result = string.concat(result, getPrinciple());
                result = string.concat(result, ";\n");
                        result = string.concat(result, getDescription());
        return result;
    }

    function getName() internal view returns (string memory){
        return string.concat(unicode"名称: ", _name);
    }

        function getWilling() internal view returns (string memory){
        return string.concat(unicode"愿景: ", willing);
    }

        function getPrinciple() internal view returns (string memory){
        return string.concat(unicode"原则: ", principle);
    }

            function getDescription() internal view returns (string memory){
        return string.concat(unicode"介绍: ", description);
    }
}

abstract contract Donation is Stock{
    
    struct Record{
        uint32 id;
        string message;
        uint256 value;
        uint256 time;
    }
    struct UserRecord{
        uint32[] recordIds;
    }
    string favour;
    mapping (uint32=>Record) recordTable;
    mapping (address=>UserRecord) userRecordMap;
    uint32 sequence;
    constructor(){
        favour = unicode"本合约账户接受捐赠并转赠给需要帮助的个体及组织";
        // recordList = new Record[](10);
        sequence = 101;
    }

    function donate(string memory _message) public payable  returns (string memory){
        require(msg.value>0,unicode"金额须大于0");
        uint32 id = ++sequence;
        if (msg.value >= 1000 gwei){
           Record memory record = Record({id:id, value: msg.value,time: block.timestamp, message: _message});
           recordTable[id] = record;

           UserRecord storage ur = userRecordMap[msg.sender];
           uint32[] storage ids = ur.recordIds;
           ids.push(id);
           emit log(ids.length);
        }

        return "Thanks!!";
    }

    function getDonateMssage() public view returns (string memory){
        return favour;
    }

    function getUserDonations() public view returns (uint[] memory){
        UserRecord memory ur = getRecordByUser(msg.sender);
        uint32[] memory ids = ur.recordIds;
        uint[] memory result = new uint[](ids.length);
        if (ids.length == 0){
            return result;
        }
        uint index =0;
        for (uint i=0; i < ids.length; i++) 
        {
            uint32 id = ids[i];
            if (id == 0){
                continue ;
            }
            Record memory r = recordTable[id];
            result[index] = (r.value);
            index ++;
          
        }
        
     
        return result;
    }

    function getRecordByUser(address user)internal view  returns (UserRecord memory){
        return userRecordMap[user];
    }
}
// 请求帮助
abstract contract Help is Donation{
   
    struct Ask{
        uint32 id;
        address account;
        string description;
        bool status; // handled or not
        uint8 stage; // 0, initial, 1: passed, 2：not passed
        string reason;
    }
    mapping (uint32 => Ask) _asks;
    mapping(address=>uint32) _userAsk;
    uint32[] _waitings;
    uint32[] _approveds;
     uint32[] _rejecteds;
    Ask _latest ; // lastest handled 
    uint32 hsequence ;

    function saveOrUpdate(Ask memory ask) internal  {
        _asks[ask.id] = ask;
    }

    function getByUser(address addr) internal view  returns (Ask storage) {
                return _asks[_userAsk[addr]];
    }

    function askForHelp(string memory desc) public returns (string memory){
        Ask memory ask = Ask(newId(), msg.sender, desc, false, 0, "");
        saveOrUpdate(ask);
        _userAsk[msg.sender] = ask.id;
        _waitings.push(ask.id);
        return "OK";
    }
    function queryHelp() public view returns (Ask memory){
        return getByUser(msg.sender);
    }

    function approveHelp(address payable  target, uint256 value) public hasAuth{
        Ask storage ask = getByUser(target);
        require(ask.account != address(0), unicode"不能为空");
        ask.status = true;
        ask.stage = 1;
        transfer(target, value);
        _latest = ask;
        _approveds.push(ask.id);
        delete _waitings[ask.id];
    }
    function rejectHelp(address payable  target, string calldata reason) public hasAuth{
        Ask storage ask = getByUser(target);
        require(ask.account != address(0), unicode"不能为空");
        ask.status = true;
        ask.reason = reason;
        ask.stage = 2;
        _latest = ask;
        _rejecteds.push(ask.id);
        delete _waitings[ask.id];
    }

    function waitings() public view returns (uint32[] memory){
        return _waitings;
    }


    function latestAsk() public view returns (Ask memory){
        return _latest;
    }
    function transfer(address payable target, uint256 value) virtual internal;
}

contract ChinaDAO is Declaration, Help{
    

    function transfer(address payable  target, uint256 value) override internal hasAuth  {
        require(address(this).balance >= value, unicode"余额不足" );
        target.transfer(value);
        
    }

    function introduction() public view  returns (string memory){
   
        return string.concat(getMessage(),getPrinciple());
    }

    function newId() internal override(Authority)  returns (uint32){
        return ++sequence;
    }
}