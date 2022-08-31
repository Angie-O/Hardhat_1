// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract BankApp {
    address public manager;
    struct Account {
        uint256 id;
        string name;
        string kraPin;
        uint256 balance;
        bool status;
    }

    // create a mapping accounts from struct Account
    mapping(address => Account) accounts;

    //creating a modifier to check if user is logged in in every step
    modifier isLoggedIn(address _user) {
        // Copy account records from storage to memory
        Account memory account = accounts[msg.sender];

        // check if account is logged in or not
        if (!account.status) {
            revert("User not logged in");
        }
        _;
    }

    constructor(string memory _name) {
        string memory name;
        manager = msg.sender;
        name = _name;
    }

    function register(
        address user,
        uint256 id,
        string memory name,
        string memory kraPin,
        uint256 balance
    ) public returns (bool) {
        require(msg.sender == manager, "Sender is not Manger");

        Account memory account = accounts[user];

        // check if account exists and notify user
        if (account.id != 0) {
            revert("Account alredy exists");
        }

        account.id = id;
        account.name = name;
        account.kraPin = kraPin;
        account.balance = balance;
        accounts[user] = account;

        return true;
    }

    function login() public returns (bool){
        address _user = msg.sender;
        Account storage account = accounts[_user];

        // check if account exists and notify user
        if (account.id == 0) {
            revert("Account already exists");
        }
        //Check if user is logged in
        if (account.status) {
            return true;
        }

        //notifying that the user is logged in
        account.status = true;
    }

    // deposit
    function deposit(uint amount) public isLoggedIn(msg.sender) {
        // Copy account records from storage to memory
        Account memory account = accounts[msg.sender];

        //update account balance to be the previous balance + amount added
        account.balance += amount;

        //overwrite the record in the storage locations
        accounts[msg.sender] = account;
    }

    function balanceOf(address _user) public view isLoggedIn(_user) returns (uint256) {
        // Copy account records from storage to memory
        Account memory account = accounts[_user];

        //return user's ccount balance
        return account.balance;

    }

}