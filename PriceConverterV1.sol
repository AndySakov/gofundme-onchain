// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverterV1 {
    function convertToUsd(uint256 amountInWei) internal view returns (uint256 priceInUSD) {
        AggregatorV3Interface priceProvider = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );

        // prettier-ignore
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceProvider.latestRoundData();

        uint256 price = uint256(answer) * 1e10;
        return (amountInWei * price) / 1e18;
    }
}