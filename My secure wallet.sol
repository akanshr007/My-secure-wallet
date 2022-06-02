// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;


//We need to create a secure ethereum wallet that can receive ether and send ether securely with
//a PIN protection feature.
contract secureWallet {
    
    uint txCount=1;

    struct userInfo {
        uint balance;
        uint PIN;
        uint txNo;
    }

    struct transaction{
        address sender;
        uint amount;
    }
    mapping(address=>userInfo) internal user;
    mapping(uint=>transaction)  internal transactionHistory;

    function deposit(uint _pin) public payable {
     if(user[msg.sender].txNo==0){
         user[msg.sender].balance += msg.value;
         user[msg.sender].txNo +=txCount;
         user[msg.sender].PIN = _pin;
         transactionHistory[user[msg.sender].txNo].sender = msg.sender;
         transactionHistory[user[msg.sender].txNo].amount = msg.value;
     }
     else{
         require(user[msg.sender].PIN==_pin,"Incorrect PIN");
         user[msg.sender].balance += msg.value;
         user[msg.sender].txNo +=txCount;
         transactionHistory[user[msg.sender].txNo].sender = msg.sender;
         transactionHistory[user[msg.sender].txNo].amount = msg.value;
     }
    }

    function send(address _to, uint _amount, uint _pin) public { 
          require(user[msg.sender].PIN==_pin,"Incorrect PIN.");
          require(user[msg.sender].balance>=_amount,"Insufficient funds.");
          user[msg.sender].balance -= _amount;
          user[_to].balance +=_amount;
          user[_to].txNo+=txCount;
          transactionHistory[user[_to].txNo].sender= msg.sender;
          transactionHistory[user[_to].txNo].amount = _amount;

     }

     function withdraw(address payable _to, uint _amount, uint _pin) public{
         require(user[msg.sender].PIN==_pin,"Incorrect PIN.");
         require(user[msg.sender].balance>=_amount,"Insufficient funds.");
         user[msg.sender].balance -= _amount;
         _to.transfer(_amount);
     }

     function checkHistory(uint _txNo, uint _pin) public view returns(transaction memory){
           require(user[msg.sender].PIN==_pin,"Incorrect PIN");
           return transactionHistory[_txNo];
     }

     function changePIN(uint _oldPIN, uint _newPIN)public{
         require(user[msg.sender].PIN==_oldPIN,"Incorrect old PIN.");
         user[msg.sender].PIN = _newPIN;
     }

     function forgotPIN(uint _lastTransactionAmount, uint _firstTransactionAmount, uint newPIN)public{
         require(transactionHistory[1].amount==_firstTransactionAmount,"Wrong first Transaction Amount.");
         require(transactionHistory[user[msg.sender].txNo].amount==_lastTransactionAmount,"Wrong last Transaction Amount.");
         user[msg.sender].PIN=newPIN;
      }

      function checkBalance() public view returns(uint){
          return user[msg.sender].balance;
      }


}