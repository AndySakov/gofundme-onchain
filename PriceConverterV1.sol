// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {PriceConsumerV3} from "./PriceConsumerV3.sol";

library PriceConverterV1 {
    function convertToUsd(uint256 amountInWei) internal returns (uint256 priceInUSD) {
        PriceConsumerV3 priceConsumer = new PriceConsumerV3();
        return priceConsumer.convert(amountInWei);
    }
}