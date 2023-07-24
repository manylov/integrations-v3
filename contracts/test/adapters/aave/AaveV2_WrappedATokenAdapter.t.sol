// SPDX-License-Identifier: UNLICENSED
// Gearbox Protocol. Generalized leverage for DeFi protocols
// (c) Gearbox Holdings, 2023
pragma solidity ^0.8.17;

import {WAD} from "@gearbox-protocol/core-v2/contracts/libraries/Constants.sol";

import {USER, CONFIGURATOR} from "@gearbox-protocol/core-v3/contracts/test/lib/constants.sol";

import {AaveV2_WrappedATokenAdapter} from "../../../adapters/aave/AaveV2_WrappedATokenAdapter.sol";
import {IWrappedAToken} from "../../../interfaces/aave/IWrappedAToken.sol";
import {Tokens} from "../../config/Tokens.sol";
import {AaveTestHelper} from "./AaveTestHelper.sol";

import "@gearbox-protocol/core-v3/contracts/interfaces/IExceptions.sol";
import {MultiCall} from "@gearbox-protocol/core-v2/contracts/libraries/MultiCall.sol";
import {MultiCallBuilder} from "@gearbox-protocol/core-v3/contracts/test/lib/MultiCallBuilder.sol";

/// @title Aave V2 wrapped aToken adapter tests
/// @notice [AAV2W]: Unit tests for Aave V2 wrapper aToken adapter
contract AaveV2_WrappedATokenAdapter_Test is AaveTestHelper {
    AaveV2_WrappedATokenAdapter public adapter;

    function setUp() public {
        _setupAaveSuite(true);

        vm.startPrank(CONFIGURATOR);
        adapter = new AaveV2_WrappedATokenAdapter(address(creditManager), waUsdc);
        creditConfigurator.allowContract(address(waUsdc), address(adapter));
        vm.label(address(adapter), "waUSDC_ADAPTER");
        vm.stopPrank();
    }

    /// @notice [AAV2W-1]: Constructor reverts on not registered tokens
    function test_AAV2W_01_constructor_reverts_on_not_registered_tokens() public {
        vm.expectRevert(TokenNotAllowedException.selector);
        new AaveV2_WrappedATokenAdapter(address(creditManager), waDai);
    }

    /// @notice [AAV2W-2]: Constructor sets correct values
    function test_AAV2W_02_constructor_sets_correct_values() public {
        assertEq(adapter.aToken(), aUsdc, "Incorrect aUSDC address");
        assertEq(adapter.underlying(), usdc, "Incorrect USDC address");
        assertEq(adapter.waTokenMask(), creditManager.tokenMasksMap(waUsdc), "Incorrect waUSDC mask");
        assertEq(adapter.aTokenMask(), creditManager.tokenMasksMap(aUsdc), "Incorrect aUSDC mask");
        assertEq(adapter.tokenMask(), creditManager.tokenMasksMap(usdc), "Incorrect USDC mask");
    }

    /// @notice [AAV2W-3]: All action functions revert if called not from the multicall
    function test_AAV2W_03_action_functions_revert_if_called_not_from_multicall() public {
        _openTestCreditAccount();

        vm.startPrank(USER);
        vm.expectRevert(CallerNotCreditFacadeException.selector);
        adapter.deposit(1);

        vm.expectRevert(CallerNotCreditFacadeException.selector);
        adapter.depositAll();

        vm.expectRevert(CallerNotCreditFacadeException.selector);
        adapter.depositUnderlying(1);

        vm.expectRevert(CallerNotCreditFacadeException.selector);
        adapter.depositAllUnderlying();

        vm.expectRevert(CallerNotCreditFacadeException.selector);
        adapter.withdraw(1);

        vm.expectRevert(CallerNotCreditFacadeException.selector);
        adapter.withdrawAll();

        vm.expectRevert(CallerNotCreditFacadeException.selector);
        adapter.withdrawUnderlying(1);

        vm.expectRevert(CallerNotCreditFacadeException.selector);
        adapter.withdrawAllUnderlying();
        vm.stopPrank();
    }

    /// @notice [AAV2W-4]: `deposit` and `depositUnderlying` work correctly
    function test_AAV2W_04_deposit_works_correctly(uint256 timedelta) public {
        vm.assume(timedelta < 3 * 365 days);
        uint256 snapshot = vm.snapshot();

        for (uint256 fromUnderlying; fromUnderlying < 2; ++fromUnderlying) {
            (address creditAccount, uint256 initialBalance) =
                fromUnderlying == 1 ? _openAccountWithToken(Tokens.USDC) : _openAccountWithAToken(Tokens.USDC);
            address tokenIn = fromUnderlying == 1 ? usdc : aUsdc;

            expectAllowance(tokenIn, creditAccount, waUsdc, 0);

            vm.warp(block.timestamp + timedelta);
            if (fromUnderlying == 0) initialBalance = tokenTestSuite.balanceOf(aUsdc, creditAccount);
            uint256 depositAmount = initialBalance / 2;

            MultiCall[] memory calls = MultiCallBuilder.build(
                MultiCall({
                    target: address(adapter),
                    callData: fromUnderlying == 1
                        ? abi.encodeCall(IWrappedAToken.depositUnderlying, (depositAmount))
                        : abi.encodeCall(IWrappedAToken.deposit, (depositAmount))
                })
            );

            expectMulticallStackCalls(
                address(adapter),
                waUsdc,
                USER,
                fromUnderlying == 1
                    ? abi.encodeCall(IWrappedAToken.depositUnderlying, (depositAmount))
                    : abi.encodeCall(IWrappedAToken.deposit, (depositAmount)),
                tokenIn,
                waUsdc,
                true
            );

            vm.prank(USER);
            creditFacade.multicall(creditAccount, calls);

            expectBalance(tokenIn, creditAccount, initialBalance - depositAmount);
            expectBalance(waUsdc, creditAccount, depositAmount * WAD / IWrappedAToken(waUsdc).exchangeRate());

            expectAllowance(tokenIn, creditAccount, waUsdc, 1);

            expectTokenIsEnabled(tokenIn, true);
            expectTokenIsEnabled(waUsdc, true);

            vm.revertTo(snapshot);
        }
    }

    /// @notice [AAV2W-5]: `depositAll` and `depositAllUnderlying` work correctly
    /// @dev Fuzzing time before deposit to see if adapter handles interest properly
    function test_AAV2W_05_depositAll_works_correctly(uint256 timedelta) public {
        vm.assume(timedelta < 3 * 365 days);
        uint256 snapshot = vm.snapshot();

        for (uint256 fromUnderlying; fromUnderlying < 2; ++fromUnderlying) {
            (address creditAccount, uint256 initialBalance) =
                fromUnderlying == 1 ? _openAccountWithToken(Tokens.USDC) : _openAccountWithAToken(Tokens.USDC);
            address tokenIn = fromUnderlying == 1 ? usdc : aUsdc;

            expectAllowance(tokenIn, creditAccount, waUsdc, 0);

            vm.warp(block.timestamp + timedelta);
            if (fromUnderlying == 0) initialBalance = tokenTestSuite.balanceOf(aUsdc, creditAccount);

            bytes memory expectedCallData = fromUnderlying == 1
                ? abi.encodeCall(IWrappedAToken.depositUnderlying, (initialBalance - 1))
                : abi.encodeCall(IWrappedAToken.deposit, (initialBalance - 1));

            MultiCall[] memory calls = MultiCallBuilder.build(
                MultiCall({
                    target: address(adapter),
                    callData: fromUnderlying == 1
                        ? abi.encodeCall(adapter.depositAllUnderlying, ())
                        : abi.encodeCall(adapter.depositAll, ())
                })
            );

            expectMulticallStackCalls(address(adapter), waUsdc, USER, expectedCallData, tokenIn, waUsdc, true);

            vm.prank(USER);
            creditFacade.multicall(creditAccount, calls);

            expectBalance(tokenIn, creditAccount, 1);
            expectBalance(waUsdc, creditAccount, (initialBalance - 1) * WAD / IWrappedAToken(waUsdc).exchangeRate());

            expectAllowance(tokenIn, creditAccount, waUsdc, 1);

            expectTokenIsEnabled(tokenIn, false);
            expectTokenIsEnabled(waUsdc, true);

            vm.revertTo(snapshot);
        }
    }

    /// @notice [AAV2W-6]: `withdraw` and `withdrawUnderlying` work correctly
    /// @dev Fuzzing time before withdrawal to see if adapter handles interest properly
    function test_AAV2W_06_withdraw_works_correctly(uint256 timedelta) public {
        vm.assume(timedelta < 3 * 365 days);
        uint256 snapshot = vm.snapshot();

        for (uint256 toUnderlying; toUnderlying < 2; ++toUnderlying) {
            (address creditAccount, uint256 initialBalance) = _openAccountWithWAToken(Tokens.USDC);
            address tokenOut = toUnderlying == 1 ? usdc : aUsdc;

            vm.warp(block.timestamp + timedelta);
            uint256 withdrawAmount = initialBalance / 2;

            MultiCall[] memory calls = MultiCallBuilder.build(
                MultiCall({
                    target: address(adapter),
                    callData: toUnderlying == 1
                        ? abi.encodeCall(IWrappedAToken.withdrawUnderlying, (withdrawAmount))
                        : abi.encodeCall(IWrappedAToken.withdraw, (withdrawAmount))
                })
            );

            expectMulticallStackCalls(
                address(adapter),
                waUsdc,
                USER,
                toUnderlying == 1
                    ? abi.encodeCall(IWrappedAToken.withdrawUnderlying, (withdrawAmount))
                    : abi.encodeCall(IWrappedAToken.withdraw, (withdrawAmount)),
                waUsdc,
                tokenOut,
                false
            );

            vm.prank(USER);
            creditFacade.multicall(creditAccount, calls);

            expectBalance(waUsdc, creditAccount, initialBalance - withdrawAmount);
            expectBalance(tokenOut, creditAccount, withdrawAmount * IWrappedAToken(waUsdc).exchangeRate() / WAD);

            expectTokenIsEnabled(waUsdc, true);
            expectTokenIsEnabled(tokenOut, true);

            vm.revertTo(snapshot);
        }
    }

    /// @notice [AAV2W-7]: `withdrawAll` and `withdrawAllUnderlying` work correctly
    /// @dev Fuzzing time before withdrawal to see if adapter handles interest properly
    function test_AAV2W_07_wirhdrawAll_works_correctly(uint256 timedelta) public {
        vm.assume(timedelta < 3 * 365 days);
        uint256 snapshot = vm.snapshot();

        for (uint256 toUnderlying; toUnderlying < 2; ++toUnderlying) {
            (address creditAccount, uint256 initialBalance) = _openAccountWithWAToken(Tokens.USDC);
            address tokenOut = toUnderlying == 1 ? usdc : aUsdc;

            vm.warp(block.timestamp + timedelta);

            bytes memory expectedCallData = toUnderlying == 1
                ? abi.encodeCall(IWrappedAToken.withdrawUnderlying, (initialBalance - 1))
                : abi.encodeCall(IWrappedAToken.withdraw, (initialBalance - 1));

            MultiCall[] memory calls = MultiCallBuilder.build(
                MultiCall({
                    target: address(adapter),
                    callData: toUnderlying == 1
                        ? abi.encodeCall(adapter.withdrawAllUnderlying, ())
                        : abi.encodeCall(adapter.withdrawAll, ())
                })
            );

            expectMulticallStackCalls(address(adapter), waUsdc, USER, expectedCallData, waUsdc, tokenOut, false);

            vm.prank(USER);
            creditFacade.multicall(creditAccount, calls);

            expectBalance(waUsdc, creditAccount, 1);
            expectBalance(tokenOut, creditAccount, (initialBalance - 1) * IWrappedAToken(waUsdc).exchangeRate() / WAD);

            expectTokenIsEnabled(waUsdc, false);
            expectTokenIsEnabled(tokenOut, true);

            vm.revertTo(snapshot);
        }
    }
}
