// SPDX-License-Identifier: UNLICENSED
// Gearbox Protocol. Generalized leverage for DeFi protocols
// (c) Gearbox Holdings, 2023
pragma solidity ^0.8.17;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ICreditFacadeV3} from "@gearbox-protocol/core-v3/contracts/interfaces/ICreditFacadeV3.sol";
import {ICurvePool2Assets} from "../../../integrations/curve/ICurvePool_2.sol";
import {ICurveV1_2AssetsAdapter} from "../../../interfaces/curve/ICurveV1_2AssetsAdapter.sol";
import {CurveV1Calls, CurveV1Multicaller} from "../../../multicall/curve/CurveV1_Calls.sol";

import {Tokens} from "../../config/Tokens.sol";
import {Contracts} from "../../config/SupportedContracts.sol";

import {MultiCall} from "@gearbox-protocol/core-v2/contracts/libraries/MultiCall.sol";

// TEST
import "@gearbox-protocol/core-v3/contracts/test/lib/constants.sol";

// SUITES
import {LiveEnvTestSuite} from "../../suites/LiveEnvTestSuite.sol";
import {LiveEnvHelper} from "../../suites/LiveEnvHelper.sol";
import {BalanceComparator, BalanceBackup} from "../../helpers/BalanceComparator.sol";

contract Live_CurveStETHEquivalenceTest is TestHelper, LiveEnvHelper {
    using CreditFacadeCalls for CreditFacadeMulticaller;
    using CurveV1Calls for CurveV1Multicaller;

    BalanceComparator comparator;

    function setUp() public liveOnly {
        _setUp();

        // TOKENS TO TRACK ["crvFRAX", "FRAX", "USDC"]
        Tokens[3] memory tokensToTrack = [Tokens.steCRV, Tokens.WETH, Tokens.STETH];

        // STAGES
        string[9] memory stages = [
            "after_exchange",
            "after_add_liquidity",
            "after_remove_liquidity",
            "after_remove_liquidity_one_coin",
            "after_remove_liquidity_imbalance",
            "after_add_liquidity_one_coin",
            "after_exchange_all",
            "after_add_all_liquidity_one_coin",
            "after_remove_all_liquidity_one_coin"
        ];

        /// @notice Sets comparator for this equivalence test

        uint256 len = stages.length;
        string[] memory _stages = new string[](len);
        unchecked {
            for (uint256 i; i < len; ++i) {
                _stages[i] = stages[i];
            }
        }

        len = tokensToTrack.length;
        Tokens[] memory _tokensToTrack = new Tokens[](len);
        unchecked {
            for (uint256 i; i < len; ++i) {
                _tokensToTrack[i] = tokensToTrack[i];
            }
        }

        comparator = new BalanceComparator(
            _stages,
            _tokensToTrack,
            tokenTestSuite
        );

        /// @notice Approves all tracked tokens for USER
        tokenTestSuite.approveMany(_tokensToTrack, USER, supportedContracts.addressOf(Contracts.CURVE_STETH_GATEWAY));
    }

    /// HELPER

    function compareBehavior(address curvePoolAddr, address accountToSaveBalances, bool isAdapter) internal {
        if (isAdapter) {
            ICreditFacadeV3 creditFacade = lts.creditFacades(Tokens.WETH);
            CurveV1Multicaller pool = CurveV1Multicaller(curvePoolAddr);

            vm.prank(USER);
            creditFacade.multicall(multicallBuilder(pool.exchange(int128(0), int128(1), 5 * WAD, WAD)));
            comparator.takeSnapshot("after_exchange", accountToSaveBalances);

            uint256[2] memory amounts = [4 * WAD, 4 * WAD];

            vm.prank(USER);
            creditFacade.multicall(multicallBuilder(pool.add_liquidity(amounts, 0)));
            comparator.takeSnapshot("after_add_liquidity", accountToSaveBalances);

            amounts = [uint256(0), 0];

            vm.prank(USER);
            creditFacade.multicall(multicallBuilder(pool.remove_liquidity(WAD, amounts)));
            comparator.takeSnapshot("after_remove_liquidity", accountToSaveBalances);

            vm.prank(USER);
            creditFacade.multicall(multicallBuilder(pool.remove_liquidity_one_coin(WAD, int128(1), 0)));
            comparator.takeSnapshot("after_remove_liquidity_one_coin", accountToSaveBalances);

            amounts = [WAD, WAD / 5];

            vm.prank(USER);
            creditFacade.multicall(multicallBuilder(pool.remove_liquidity_imbalance(amounts, 2 * WAD)));
            comparator.takeSnapshot("after_remove_liquidity_imbalance", accountToSaveBalances);

            vm.prank(USER);
            creditFacade.multicall(multicallBuilder(pool.add_liquidity_one_coin(WAD, int128(0), WAD / 2)));
            comparator.takeSnapshot("after_add_liquidity_one_coin", accountToSaveBalances);

            vm.prank(USER);
            creditFacade.multicall(multicallBuilder(pool.exchange_all(int128(0), int128(1), RAY / 2)));
            comparator.takeSnapshot("after_exchange_all", accountToSaveBalances);

            vm.prank(USER);
            creditFacade.multicall(multicallBuilder(pool.add_all_liquidity_one_coin(int128(1), RAY / 2)));
            comparator.takeSnapshot("after_add_all_liquidity_one_coin", accountToSaveBalances);

            vm.prank(USER);
            creditFacade.multicall(multicallBuilder(pool.remove_all_liquidity_one_coin(int128(0), RAY / 2)));
            comparator.takeSnapshot("after_remove_all_liquidity_one_coin", accountToSaveBalances);
        } else {
            ICurvePool2Assets pool = ICurvePool2Assets(curvePoolAddr);

            vm.prank(USER);
            pool.exchange(int128(0), int128(1), 5 * WAD, WAD);
            comparator.takeSnapshot("after_exchange", accountToSaveBalances);

            uint256[2] memory amounts = [4 * WAD, 4 * WAD];

            vm.prank(USER);
            pool.add_liquidity(amounts, 0);
            comparator.takeSnapshot("after_add_liquidity", accountToSaveBalances);

            amounts = [uint256(0), 0];

            vm.prank(USER);
            pool.remove_liquidity(WAD, amounts);
            comparator.takeSnapshot("after_remove_liquidity", accountToSaveBalances);

            vm.prank(USER);
            pool.remove_liquidity_one_coin(WAD, int128(1), 0);
            comparator.takeSnapshot("after_remove_liquidity_one_coin", accountToSaveBalances);

            amounts = [WAD, WAD / 5];

            vm.prank(USER);
            pool.remove_liquidity_imbalance(amounts, 2 * WAD);
            comparator.takeSnapshot("after_remove_liquidity_imbalance", accountToSaveBalances);

            vm.prank(USER);
            pool.add_liquidity([WAD, 0], WAD / 2);
            comparator.takeSnapshot("after_add_liquidity_one_coin", accountToSaveBalances);

            uint256 balanceToSwap = tokenTestSuite.balanceOf(Tokens.WETH, accountToSaveBalances) - 1;
            vm.prank(USER);
            pool.exchange(int128(0), int128(1), balanceToSwap, balanceToSwap / 2);
            comparator.takeSnapshot("after_exchange_all", accountToSaveBalances);

            balanceToSwap = tokenTestSuite.balanceOf(Tokens.STETH, accountToSaveBalances) - 1;
            vm.prank(USER);
            pool.add_liquidity([0, balanceToSwap], balanceToSwap / 2);
            comparator.takeSnapshot("after_add_all_liquidity_one_coin", accountToSaveBalances);

            balanceToSwap = tokenTestSuite.balanceOf(Tokens.steCRV, accountToSaveBalances) - 1;
            vm.prank(USER);
            pool.remove_liquidity_one_coin(balanceToSwap, int128(0), balanceToSwap / 2);
            comparator.takeSnapshot("after_remove_all_liquidity_one_coin", accountToSaveBalances);
        }
    }

    /// @dev Opens credit account for USER and make amount of desired token equal
    /// amounts for USER and CA to be able to launch test for both
    function openCreditAccountWithEqualAmount(uint256 amount) internal returns (address creditAccount) {
        ICreditFacadeV3 creditFacade = lts.creditFacades(Tokens.WETH);

        tokenTestSuite.mint(Tokens.WETH, USER, 3 * amount);

        // Approve tokens
        tokenTestSuite.approve(Tokens.WETH, USER, address(lts.creditManagers(Tokens.WETH)));

        vm.startPrank(USER);
        creditFacade.openCreditAccountMulticall(
            amount,
            USER,
            multicallBuilder(
                CreditFacadeMulticaller(address(creditFacade)).addCollateral(
                    USER, tokenTestSuite.addressOf(Tokens.WETH), amount
                )
            ),
            0
        );

        vm.stopPrank();

        creditAccount = lts.creditManagers(Tokens.WETH).getCreditAccountOrRevert(USER);
    }

    /// @dev [L-CRVET-6]: stETH adapter and normal account works identically
    function test_live_CRVET_06_stETH_adapter_and_normal_account_works_identically() public liveOnly {
        ICreditFacadeV3 creditFacade = lts.creditFacades(Tokens.WETH);

        (uint256 minAmount,) = creditFacade.limits();

        address creditAccount = openCreditAccountWithEqualAmount(minAmount);

        uint256 snapshot = vm.snapshot();

        compareBehavior(supportedContracts.addressOf(Contracts.CURVE_STETH_GATEWAY), USER, false);

        /// Stores save balances in memory, because all state data would be reverted afer snapshot
        BalanceBackup[] memory savedBalanceSnapshots = comparator.exportSnapshots(USER);

        vm.revertTo(snapshot);

        compareBehavior(lts.getAdapter(Tokens.WETH, Contracts.CURVE_STETH_GATEWAY), creditAccount, true);

        comparator.compareAllSnapshots(creditAccount, savedBalanceSnapshots);
    }
}
