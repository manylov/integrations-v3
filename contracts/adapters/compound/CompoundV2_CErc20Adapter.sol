// SPDX-License-Identifier: GPL-2.0-or-later
// Gearbox Protocol. Generalized leverage for DeFi protocols
// (c) Gearbox Holdings, 2023
pragma solidity ^0.8.17;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {AdapterType} from "../../interfaces/IAdapter.sol";

import {CompoundV2_CTokenAdapter} from "./CompoundV2_CTokenAdapter.sol";
import {ICErc20} from "../../integrations/compound/ICErc20.sol";
import {ICompoundV2_CTokenAdapter} from "../../interfaces/compound/ICompoundV2_CTokenAdapter.sol";

/// @title Compound V2 CErc20 adapter
contract CompoundV2_CErc20Adapter is CompoundV2_CTokenAdapter {
    /// @inheritdoc ICompoundV2_CTokenAdapter
    address public immutable override underlying;

    /// @inheritdoc ICompoundV2_CTokenAdapter
    uint256 public immutable override tokenMask;

    /// @inheritdoc ICompoundV2_CTokenAdapter
    uint256 public immutable override cTokenMask;

    AdapterType public constant override _gearboxAdapterType = AdapterType.COMPOUND_V2_CERC20;
    uint16 public constant override _gearboxAdapterVersion = 1;

    /// @notice Constructor
    /// @param _creditManager Credit manager address
    /// @param _cToken CErc20 token address
    constructor(address _creditManager, address _cToken) CompoundV2_CTokenAdapter(_creditManager, _cToken) {
        underlying = ICErc20(targetContract).underlying(); // F: [ACV2CERC-2]

        cTokenMask = _getMaskOrRevert(targetContract); // F: [ACV2CERC-1, ACV2CERC-2]
        tokenMask = _getMaskOrRevert(underlying); // F: [ACV2CERC-2]
    }

    /// @inheritdoc ICompoundV2_CTokenAdapter
    function cToken() external view override returns (address) {
        return targetContract; // F: [ACV2CERC-2]
    }

    /// -------------------------------- ///
    /// VIRTUAL FUNCTIONS IMPLEMENTATION ///
    /// -------------------------------- ///

    /// @dev Internal implementation of `mint`
    ///      - underlying is approved before the call because cToken needs permission to transfer it
    ///      - cToken is enabled after the call
    ///      - underlying is not disabled after the call because operation doesn't spend the entire balance
    function _mint(uint256 amount)
        internal
        override
        returns (uint256 tokensToEnable, uint256 tokensToDisable, uint256 error)
    {
        _approveToken(underlying, type(uint256).max);
        error = abi.decode(_execute(_encodeMint(amount)), (uint256));
        _approveToken(underlying, 1);
        (tokensToEnable, tokensToDisable) = (cTokenMask, 0);
    }

    /// @dev Internal implementation of `mintAll`
    ///      - underlying is approved before the call because cToken needs permission to transfer it
    ///      - cToken is enabled after the call
    ///      - underlying is disabled after the call because operation spends the entire balance
    function _mintAll() internal override returns (uint256 tokensToEnable, uint256 tokensToDisable, uint256 error) {
        address creditAccount = _creditAccount();
        uint256 balance = IERC20(underlying).balanceOf(creditAccount);
        if (balance <= 1) return (0, 0, 0);

        uint256 amount;
        unchecked {
            amount = balance - 1;
        }

        _approveToken(underlying, type(uint256).max);
        error = abi.decode(_execute(_encodeMint(amount)), (uint256));
        _approveToken(underlying, 1);
        (tokensToEnable, tokensToDisable) = (cTokenMask, tokenMask);
    }

    /// @dev Internal implementation of `redeem`
    ///      - cToken is not approved before the call because cToken doesn't need permission to burn it
    ///      - underlying is enabled after the call
    ///      - cToken is not disabled after the call because operation doesn't spend the entire balance
    function _redeem(uint256 amount)
        internal
        override
        returns (uint256 tokensToEnable, uint256 tokensToDisable, uint256 error)
    {
        error = abi.decode(_execute(_encodeRedeem(amount)), (uint256));
        (tokensToEnable, tokensToDisable) = (tokenMask, 0);
    }

    /// @dev Internal implementation of `redeemAll`
    ///      - cToken is not approved before the call because cToken doesn't need permission to burn it
    ///      - underlying is enabled after the call
    ///      - cToken is disabled after the call because operation spends the entire balance
    function _redeemAll() internal override returns (uint256 tokensToEnable, uint256 tokensToDisable, uint256 error) {
        address creditAccount = _creditAccount();
        uint256 balance = ICErc20(targetContract).balanceOf(creditAccount);
        if (balance <= 1) return (0, 0, 0);

        uint256 amount;
        unchecked {
            amount = balance - 1;
        }

        error = abi.decode(_execute(_encodeRedeem(amount)), (uint256));
        (tokensToEnable, tokensToDisable) = (tokenMask, cTokenMask);
    }

    /// @dev Internal implementation of `redeemUnderlying`
    ///      - cToken is not approved before the call because cToken doesn't need permission to burn it
    ///      - underlying is enabled after the call
    ///      - cToken is not disabled after the call because operation doesn't spend the entire balance
    function _redeemUnderlying(uint256 amount)
        internal
        override
        returns (uint256 tokensToEnable, uint256 tokensToDisable, uint256 error)
    {
        error = abi.decode(_execute(_encodeRedeemUnderlying(amount)), (uint256));
        (tokensToEnable, tokensToDisable) = (tokenMask, 0);
    }
}
