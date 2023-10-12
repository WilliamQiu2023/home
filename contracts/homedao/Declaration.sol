// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Declaration is ERC20 {
    
    string private declaration;
    string private vision;
    string private principle;

    constructor(){
        super("HOME DAO","HMC")
        declaration = "We construct Home DAO now.";
        vision = "To make a better virtual world that likes our home for all human beings .";
        principle = "equality, love, willing";
    }
}