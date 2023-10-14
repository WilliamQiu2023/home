// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {CommLib} from "./util/CommLib.sol";

import "./Administrator.sol";

abstract contract Declaration{
    string _name;
    string  _willing;
    string  _principle;
    string _description;
    constructor(){
        _name = unicode"中国去中心化自治组织发展促进协会";
        _willing = unicode"促进中文社区的自治化组织发展";
        _principle = unicode"平等，爱，互助";
        _description = unicode"此协会本身为DAO(去中心化自治组织)，无官方属性";
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
}

abstract contract Donation is Administrate{

    string favour;

    // mapping (address=>uint64) _donates;

    constructor(){
        favour = unicode"本合约账户接受捐赠并转赠给需要帮助的个体及组织";
    }
    event logDonate(string,address,uint);
    function donate(string memory _message) public payable  returns (string memory){
        require(msg.value>0,"money needed");
        // uint64 id = newId();
        // _donates[msg.sender] = id;
        emit logDonate(string.concat("thanks donate! message:",_message),msg.sender, msg.value);
        
        return "Thanks!!";
    }

    function getDonateDesc() public view returns (string memory){
        return favour;
    }

}
// 请求帮助
abstract contract Help is Donation{
     using CommLib for address;
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
    function etrade(address payable target, uint256 value) virtual internal;
}

contract ChinaDAO is Declaration, Help{
    
    uint64 seq;
    event logEtrade(string,address,uint);
    function etrade(address payable  t, uint256 value) override internal hasAuth  {
        require(address(this).balance >= value, "bal lmt" );
        t.transfer(value);
         emit logEtrade("etracd result:",t,value);
    }

    function introduction() public view  returns (string memory){
   
        return string.concat(getDeclaration(),";",getDonateDesc());
    }

    function newId() internal override  returns (uint64){
         seq++;
         return seq;
    }
}