// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {PriceConverterV1} from "./PriceConverterV1.sol";

error NotOwner();
error DelegateAlreadySet(address existingDelegate);
error FundingClosed();
error NotEnoughEth(uint256 minimumUsd);

contract FundMe {
    using PriceConverterV1 for uint256;

    uint256 public constant MINIMUM_USD = 5e18;

    address immutable i_owner;
    bool public openForDonations;
    bool public collectionDelegated;
    address payable public collectionDelegate;
    
    address[] public funders;
    mapping(address => uint256) public userDeposits;

    constructor() {
        i_owner = msg.sender;
        openForDonations = true;
    }

    modifier onlyOwner {
        require(msg.sender == i_owner, NotOwner());
        _;
    }

    // restricted the delegate to be set once just for concept purposes. probably a bad idea incase the owner makes a mistake the first time lol.
    function setDelegate(address delegate) public onlyOwner {
        require(!collectionDelegated, DelegateAlreadySet({
            existingDelegate: collectionDelegate
        }));
        collectionDelegated = true;
        collectionDelegate = payable (delegate);
    }

    function fund() public payable {
        require(openForDonations, FundingClosed());
        require(msg.value.convertToUsd() > MINIMUM_USD, NotEnoughEth({minimumUsd: MINIMUM_USD}));
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
            payable (i_owner).transfer(address(this).balance);
        }
    }

    function balance() public view returns (uint256) {
        return address(this).balance;
    }

    function balanceUsd() public view returns (uint256) {
        return balance().convertToUsd();
    }
}