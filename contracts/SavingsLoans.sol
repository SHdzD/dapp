// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SavingsLoans {
    address public owner;

    struct User {
        uint256 balance;
        uint256 collateral;
        uint256 loan;
    }

    mapping(address => User) public users;

    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);
    event LoanRequested(address indexed user, uint256 amount, uint256 collateral);
    event LoanRepaid(address indexed user, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    function deposit() external payable {
        require(msg.value > 0, "You must deposit some ETH.");
        users[msg.sender].balance += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        require(users[msg.sender].balance >= amount, "Insufficient balance.");
        users[msg.sender].balance -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }

    function requestLoan() external payable {
        require(msg.value > 0, "Collateral is required.");
        uint256 loanAmount = msg.value * 2;
        users[msg.sender].collateral += msg.value;
        users[msg.sender].loan += loanAmount;
        payable(msg.sender).transfer(loanAmount);
        emit LoanRequested(msg.sender, loanAmount, msg.value);
    }

    function repayLoan() external payable {
        require(msg.value == users[msg.sender].loan, "Incorrect repayment amount.");
        users[msg.sender].loan = 0;
        payable(msg.sender).transfer(users[msg.sender].collateral);
        users[msg.sender].collateral = 0;
        emit LoanRepaid(msg.sender, msg.value);
    }

    function getBalance() public view returns (uint256) {
        return users[msg.sender].balance;
    }
}
