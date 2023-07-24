// SPDX-License-Identifier: UNLICENSED
// Gearbox Protocol. Generalized leverage for DeFi protocols
// (c) Gearbox Holdings, 2023
pragma solidity ^0.8.17;

import {
    ICreditManagerV3,
    ICreditManagerV3Events
} from "@gearbox-protocol/core-v3/contracts/interfaces/ICreditManagerV3.sol";
import {ICreditFacadeV3Events} from "@gearbox-protocol/core-v3/contracts/interfaces/ICreditFacadeV3.sol";

// TEST
import "../lib/constants.sol";

// SUITES
import {TokensTestSuite} from "../suites/TokensTestSuite.sol";
import {Tokens} from "../config/Tokens.sol";

import {BalanceHelper} from "../helpers/BalanceHelper.sol";
import {IntegrationTestHelper} from "@gearbox-protocol/core-v3/contracts/test/helpers/IntegrationTestHelper.sol";
import {CreditConfig} from "../config/CreditConfig.sol";

import {TestHelper} from "@gearbox-protocol/core-v3/contracts/test/lib/helper.sol";

contract AdapterTestHelper is ICreditManagerV3Events, ICreditFacadeV3Events, IntegrationTestHelper {
    // function _setUp() internal {
    //     _setUp(Tokens.DAI);
    // }

    // function _setUp(Tokens t) internal {
    //     require(t == Tokens.DAI || t == Tokens.WETH || t == Tokens.STETH, "Unsupported token");

    //     tokenTestSuite = new TokensTestSuite();
    //     tokenTestSuite.topUpWETH{value: 100 * WAD}();

    //     CreditConfig creditConfig = new CreditConfig(tokenTestSuite, t);

    //     cft = new CreditFacadeTestSuite(creditConfig);

    //     underlying = cft.underlying();

    //     creditManager = cft.creditManager();
    //     creditFacade = cft.creditFacade();
    //     creditConfigurator = cft.creditConfigurator();
    // }

    function _getUniswapDeadline() internal view returns (uint256) {
        return block.timestamp + 1;
    }

    function expectMulticallStackCalls(
        address creditAccount,
        address, // adapter,
        address targetContract,
        address borrower,
        bytes memory callData,
        address tokenIn,
        address, // tokenOut,
        bool allowTokenIn
    ) internal {
        vm.expectEmit(true, false, false, false);
        emit StartMultiCall(creditAccount, borrower);

        if (allowTokenIn) {
            vm.expectCall(
                address(creditManager),
                abi.encodeCall(ICreditManagerV3.approveCreditAccount, (targetContract, tokenIn, type(uint256).max))
            );
        }

        vm.expectCall(address(creditManager), abi.encodeCall(ICreditManagerV3.executeOrder, (targetContract, callData)));

        vm.expectEmit(true, false, false, false);
        emit Execute(targetContract);

        if (allowTokenIn) {
            vm.expectCall(
                address(creditManager),
                abi.encodeCall(ICreditManagerV3.approveCreditAccount, (targetContract, tokenIn, 1))
            );
        }

        vm.expectEmit(false, false, false, false);
        emit FinishMultiCall();
    }
}
