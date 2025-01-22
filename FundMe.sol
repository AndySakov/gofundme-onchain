// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {PriceConverterV1} from "./PriceConverterV1.sol";

contract FundMe {
    using PriceConverterV1 for uint256;

    address owner;
    bool public openForDonations;
    bool public collectionDelegated;
    address payable collectionDelegate;
    uint256 public minimumUsd = 5e18;
    address[] funders;
    mapping(address => uint256) public userDeposits;

    constructor() {
        owner = msg.sender;
        openForDonations = true;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    // restricted the delegate to be set once just for concept purposes. probably a bad idea incase the owner makes a mistake the first time lol.
    function setDelegate(address delegate) public onlyOwner {
        require(!collectionDelegated, "Collection delegate has already been set");
        collectionDelegated = true;
        collectionDelegate = payable (delegate);
    }

    function fund() public payable {
        require(openForDonations, "Funding is closed");
        require(msg.value.convertToUsd() > minimumUsd, "Didn't send enough eth");
        funders.push(msg.sender);
        userDeposits[msg.sender] += msg.value;
    }

    // would probably be smarter to have the delegate be passed as a param here but i chose to go with the setter strategy for concept purpose.
    function withdraw() public payable onlyOwner { 
        openForDonations = false;
        for (uint256 index; index < funders.length; index++) 
        {
            address funder = funders[index];
            delete userDeposits[funder];
        }
        funders = new address[](0);

        if(collectionDelegated) {
            collectionDelegate.transfer(address(this).balance);
        } else {
            payable (owner).transfer(address(this).balance);
        }
    }

    function balance() public view returns (uint256) {
        return address(this).balance;
    }

    function balanceUsd() public view returns (uint256) {
        return balance().convertToUsd();
    }
}