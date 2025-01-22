// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {PriceConverterV1} from "./PriceConverterV1.sol";

contract FundMe {
    using PriceConverterV1 for uint256;

    address owner;
    bool public openForDonations;
    uint256 public minimumUsd = 5e18;
    address[] funders;
    mapping(address => uint256) public userDeposits;

    constructor() {
        owner = msg.sender;
        openForDonations = true;
    }

    function fund() public payable {
        require(openForDonations, "Funding is closed");
        require(msg.value.convertToUsd() > minimumUsd, "Didn't send enough eth");
        funders.push(msg.sender);
        userDeposits[msg.sender] += msg.value;
    }

    function withdraw() public payable {
        require(msg.sender == owner, "Only owner can withdraw");

        openForDonations = false;
        for (uint256 index; index < funders.length; index++) 
        {
            address funder = funders[index];
            delete userDeposits[funder];
        }
        funders = new address[](0);
        payable (owner).transfer(address(this).balance);
    }

    function balance() public view returns (uint256) {
        return address(this).balance;
    }
}