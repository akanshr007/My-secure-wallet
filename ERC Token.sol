//SPDX-License-Identifier:UNLICENSED

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract AToken is ERC20, Ownable{
uint a;
    constructor(string memory name, string memory symbol, uint amount) ERC20(name,symbol) {

        _mint(msg.sender,amount10**18);
    }

   function mint(address to, uint amount) public onlyOwner{
        _mint(to,amount10**18);
    }

}