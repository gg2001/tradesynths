// SPDX-License-Identifier: MIT
pragma solidity ^0.7.5;

import {
    Initializable
} from "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";
import {ICurve} from "./interfaces/ICurve.sol";
import {ISynthetix} from "./interfaces/ISynthetix.sol";
import {IERC20Permit} from "./interfaces/IERC20Permit.sol";
import {IBPool} from "./interfaces/IBPool.sol";

contract TradeSynths is Initializable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    using SafeERC20 for IERC20Permit;

    ICurve public constant Curve =
        ICurve(0xA5407eAE9Ba41422680e2e00537571bcC53efBfD);
    ISynthetix public constant Synthetix =
        ISynthetix(0x97767D7D04Fd0dB0A1a2478DCd4BA85290556B48);
    IBPool public constant BPool =
        IBPool(0x055dB9AFF4311788264798356bbF3a733AE181c6);
    IERC20 public constant SUSD =
        IERC20(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51);

    function exchangeSynthetixStableWithPermit(
        IERC20Permit stable,
        int128 sellTokenId,
        uint256 amount,
        uint256 minBuyToken,
        bytes32 currencyKey,
        uint256 _deadline,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) external returns (uint256) {
        stable.permit(msg.sender, address(this), amount, _deadline, _v, _r, _s);
        stable.safeTransferFrom(msg.sender, address(this), amount);

        return _exchangeSynthetixStable(stable, sellTokenId, amount, minBuyToken, currencyKey);
    }

    function _exchangeSynthetixStable(
        IERC20Permit stable,
        int128 sellTokenId,
        uint256 amount,
        uint256 minBuyToken,
        bytes32 currencyKey
    ) internal returns (uint256) {
        Curve.exchange(
            sellTokenId,
            3, // SUSD
            amount,
            minBuyToken
        );

        uint256 exchangedAmount = SUSD.balanceOf(address(this));

        return exchangedAmount;
    }
}
