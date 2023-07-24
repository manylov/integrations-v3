// SPDX-License-Identifier: UNLICENSED
// Gearbox Protocol. Generalized leverage for DeFi protocols
// (c) Gearbox Holdings, 2023
pragma solidity ^0.8.17;

import {CreditManagerV3} from "@gearbox-protocol/core-v3/contracts/credit/CreditManagerV3.sol";

import {IBooster} from "../../../integrations/convex/IBooster.sol";
import {IBaseRewardPool} from "../../../integrations/convex/IBaseRewardPool.sol";

import {IPriceOracleV2Ext} from "@gearbox-protocol/core-v2/contracts/interfaces/IPriceOracleV2.sol";

import {ConvexV1BaseRewardPoolAdapter} from "../../../adapters/convex/ConvexV1_BaseRewardPool.sol";
import {ConvexV1BoosterAdapter} from "../../../adapters/convex/ConvexV1_Booster.sol";
import {ConvexStakedPositionToken} from "../../../adapters/convex/ConvexV1_StakedPositionToken.sol";

import {BoosterMock} from "../../mocks/integrations/ConvexBoosterMock.sol";
import {BaseRewardPoolMock} from "../../mocks/integrations/ConvexBaseRewardPoolMock.sol";
import {ExtraRewardPoolMock} from "../../mocks/integrations/ConvexExtraRewardPoolMock.sol";

import {PriceFeedMock} from "../../mocks/oracles/PriceFeedMock.sol";

import {WAD, RAY} from "@gearbox-protocol/core-v2/contracts/libraries/Constants.sol";
import {ERC20Mock} from "@gearbox-protocol/core-v3/contracts/test/mocks/token/ERC20Mock.sol";

import {AdapterTestHelper} from "../AdapterTestHelper.sol";

import {USER, CONFIGURATOR, DAI_MIN_BORROWED_AMOUNT, DAI_MAX_BORROWED_AMOUNT} from "../../lib/constants.sol";

uint256 constant CURVE_LP_AMOUNT = 10000 * RAY;
uint256 constant REWARD_AMOUNT = RAY;
uint256 constant REWARD_AMOUNT1 = RAY * 33;
uint256 constant REWARD_AMOUNT2 = RAY * 4;

/// @title ConvexAdapterHelper
/// @notice Designed for unit test purposes only
contract ConvexAdapterHelper is AdapterTestHelper {
    PriceFeedMock public feed;
    IPriceOracleV2Ext public priceOracle;

    address public crv;
    address public cvx;

    address public curveLPToken;
    address public convexLPToken;
    address public phantomToken;
    address public extraRewardToken1;
    address public extraRewardToken2;

    BoosterMock public boosterMock;
    BaseRewardPoolMock public basePoolMock;
    ExtraRewardPoolMock public extraPoolMock1;
    ExtraRewardPoolMock public extraPoolMock2;

    ConvexV1BaseRewardPoolAdapter public basePoolAdapter;
    ConvexV1BoosterAdapter public boosterAdapter;

    struct PoolInfo {
        address lptoken;
        address token;
        address gauge;
        address crvRewards;
        address stash;
        bool shutdown;
    }

    function _setupConvexSuite(uint256 extraRewardsCount) internal {
        _setUp();

        feed = new PriceFeedMock(1000, 8);
        priceOracle = cft.priceOracle();

        curveLPToken = address(new ERC20Mock("Curve LP Token", "CRVLP", 18));
        _addToken(curveLPToken);

        crv = address(new ERC20Mock("Curve", "CRV", 18));
        _addToken(crv);

        cvx = address(new ERC20Mock("Convex", "CVX", 18));
        _addToken(cvx);

        if (extraRewardsCount >= 1) {
            extraRewardToken1 = address(new ERC20Mock("Extra Reward 1", "EXTR1", 18));
            _addToken(extraRewardToken1);
        }

        if (extraRewardsCount >= 2) {
            extraRewardToken2 = address(new ERC20Mock("Extra Reward 2", "EXTR2", 18));
            _addToken(extraRewardToken2);
        }

        boosterMock = new BoosterMock(crv, cvx);
        boosterMock.addPool(curveLPToken);

        IBooster.PoolInfo memory pool = IBooster(address(boosterMock)).poolInfo(0);

        convexLPToken = pool.token;
        _addToken(convexLPToken);

        basePoolMock = BaseRewardPoolMock(pool.crvRewards);

        if (extraRewardsCount >= 1) {
            extraPoolMock1 = new ExtraRewardPoolMock(
                address(basePoolMock),
                extraRewardToken1,
                address(boosterMock)
            );

            basePoolMock.addExtraReward(address(extraPoolMock1));
        }

        if (extraRewardsCount >= 2) {
            extraPoolMock2 = new ExtraRewardPoolMock(
                address(basePoolMock),
                extraRewardToken2,
                address(boosterMock)
            );

            basePoolMock.addExtraReward(address(extraPoolMock2));
        }

        phantomToken = address(new ConvexStakedPositionToken(address(basePoolMock), convexLPToken));
        _addToken(phantomToken);

        basePoolAdapter = new ConvexV1BaseRewardPoolAdapter(
            address(creditManager),
            address(basePoolMock),
            phantomToken
        );

        vm.prank(CONFIGURATOR);
        creditConfigurator.allowContract(address(basePoolMock), address(basePoolAdapter));

        boosterAdapter = new ConvexV1BoosterAdapter(
            address(creditManager),
            address(boosterMock)
        );

        vm.prank(CONFIGURATOR);
        creditConfigurator.allowContract(address(boosterMock), address(boosterAdapter));

        vm.prank(CONFIGURATOR);
        boosterAdapter.updateStakedPhantomTokensMap();
    }

    function _checkPoolAdapterConstructorRevert(uint256 forgottenToken) internal {
        address curveLPToken_c = address(new ERC20Mock("Curve LP Token", "CRVLP", 18));

        address crv_c = address(new ERC20Mock("Curve", "CRV", 18));
        address cvx_c = address(new ERC20Mock("Convex", "CVX", 18));
        address extraRewardToken1_c = address(new ERC20Mock("Extra Reward 1", "EXTR1", 18));
        address extraRewardToken2_c = address(new ERC20Mock("Extra Reward 2", "EXTR2", 18));

        BoosterMock boosterMock_c = new BoosterMock(crv_c, cvx_c);
        boosterMock_c.addPool(curveLPToken_c);

        IBooster.PoolInfo memory pool = IBooster(address(boosterMock_c)).poolInfo(0);

        BaseRewardPoolMock basePoolMock_c = BaseRewardPoolMock(pool.crvRewards);

        ExtraRewardPoolMock extraPoolMock1_c = new ExtraRewardPoolMock(
            address(basePoolMock_c),
            extraRewardToken1_c,
            address(boosterMock_c)
        );
        basePoolMock_c.addExtraReward(address(extraPoolMock1_c));

        ExtraRewardPoolMock extraPoolMock2_c = new ExtraRewardPoolMock(
            address(basePoolMock_c),
            extraRewardToken2_c,
            address(boosterMock_c)
        );
        basePoolMock_c.addExtraReward(address(extraPoolMock2_c));

        address convexLPToken_c = pool.token;
        address phantomToken_c = address(new ConvexStakedPositionToken(address(basePoolMock_c), convexLPToken_c));

        address forgottenTokenAddr;

        if (forgottenToken == 0) {
            forgottenTokenAddr = convexLPToken_c;
        } else {
            _addToken(convexLPToken_c);
        }

        if (forgottenToken == 1) {
            forgottenTokenAddr = phantomToken_c;
        } else {
            _addToken(phantomToken_c);
        }

        if (forgottenToken == 2) {
            forgottenTokenAddr = curveLPToken_c;
        } else {
            _addToken(curveLPToken_c);
        }

        if (forgottenToken == 3) {
            forgottenTokenAddr = crv_c;
        } else {
            _addToken(crv_c);
        }

        if (forgottenToken == 4) {
            forgottenTokenAddr = cvx_c;
        } else {
            _addToken(cvx_c);
        }

        if (forgottenToken == 5) {
            forgottenTokenAddr = extraRewardToken1_c;
        } else {
            _addToken(extraRewardToken1_c);
        }

        if (forgottenToken == 6) {
            forgottenTokenAddr = extraRewardToken2_c;
        } else {
            _addToken(extraRewardToken2_c);
        }

        vm.expectRevert(TokenNotAllowedException.selector);
        new ConvexV1BaseRewardPoolAdapter(
            address(creditManager),
            address(basePoolMock_c),
            phantomToken_c
        );
    }

    function _addToken(address token) internal {
        vm.startPrank(CONFIGURATOR);
        priceOracle.addPriceFeed(token, address(feed));
        creditConfigurator.addCollateralToken(token, 9300);
        vm.stopPrank();
    }

    function _makeRewardTokensMask(uint256 numExtras) internal view returns (uint256) {
        uint256 rewardTokensMask = creditManager.tokenMasksMap(crv) | creditManager.tokenMasksMap(cvx);
        if (numExtras >= 1) rewardTokensMask |= creditManager.tokenMasksMap(extraRewardToken1);
        if (numExtras >= 2) rewardTokensMask |= creditManager.tokenMasksMap(extraRewardToken2);
        return rewardTokensMask;
    }

    function expectDepositStackCalls(address borrower, uint256 amount, bool stake, bool depositAll) internal {
        bytes memory callData = depositAll
            ? abi.encodeCall(IBooster.depositAll, (0, stake))
            : abi.encodeCall(IBooster.deposit, (0, amount, stake));

        expectMulticallStackCalls(
            address(boosterAdapter),
            address(boosterMock),
            borrower,
            callData,
            curveLPToken,
            stake ? phantomToken : convexLPToken,
            true
        );
    }

    function expectWithdrawStackCalls(address borrower, uint256 amount, bool withdrawAll) internal {
        bytes memory callData =
            withdrawAll ? abi.encodeCall(IBooster.withdrawAll, (0)) : abi.encodeCall(IBooster.withdraw, (0, amount));

        expectMulticallStackCalls(
            address(boosterAdapter), address(boosterMock), borrower, callData, convexLPToken, curveLPToken, false
        );
    }

    function expectStakeStackCalls(address borrower, uint256 amount, bool stakeAll) internal {
        bytes memory callData =
            stakeAll ? abi.encodeCall(IBaseRewardPool.stakeAll, ()) : abi.encodeCall(IBaseRewardPool.stake, (amount));

        expectMulticallStackCalls(
            address(basePoolAdapter), address(basePoolMock), borrower, callData, convexLPToken, phantomToken, true
        );
    }

    function expectPoolWithdrawStackCalls(
        address borrower,
        uint256 amount,
        bool withdrawAll,
        bool unwrap,
        uint256 numExtras
    ) internal {
        bytes memory callData;

        if (unwrap) {
            callData = withdrawAll
                ? abi.encodeCall(IBaseRewardPool.withdrawAllAndUnwrap, (true))
                : abi.encodeCall(IBaseRewardPool.withdrawAndUnwrap, (amount, true));
        } else {
            callData = withdrawAll
                ? abi.encodeCall(IBaseRewardPool.withdrawAll, (true))
                : abi.encodeCall(IBaseRewardPool.withdraw, (amount, true));
        }

        expectMulticallStackCalls(
            address(basePoolAdapter),
            address(basePoolMock),
            borrower,
            callData,
            phantomToken,
            unwrap ? curveLPToken : convexLPToken,
            false
        );

        uint256 stakingTokenMask = creditManager.tokenMasksMap(unwrap ? curveLPToken : convexLPToken);
        uint256 stakedTokenMask = creditManager.tokenMasksMap(phantomToken);
        uint256 rewardTokensMask = _makeRewardTokensMask(numExtras);
        vm.expectCall(
            address(creditManager),
            abi.encodeCall(
                creditManager.changeEnabledTokens,
                (rewardTokensMask | stakingTokenMask, withdrawAll ? stakedTokenMask : 0)
            )
        );
    }

    function expectClaimStackCalls(address borrower, uint256 numExtras) internal {
        vm.expectEmit(true, false, false, false);
        emit MultiCallStarted(borrower);

        vm.expectEmit(true, false, false, false);
        emit ExecuteOrder(address(basePoolMock));

        vm.expectCall(address(basePoolMock), abi.encodeWithSignature("getReward()"));
        vm.expectCall(
            address(creditManager),
            abi.encodeCall(creditManager.changeEnabledTokens, (_makeRewardTokensMask(numExtras), 0))
        );

        vm.expectEmit(false, false, false, false);
        emit MultiCallFinished();
    }
}
