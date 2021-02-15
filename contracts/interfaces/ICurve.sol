// SPDX-License-Identifier: MIT
pragma solidity ^0.7.5;

interface ICurve {
    function underlying_coins(int128 tokenId)
        external
        view
        returns (address token);

    function calc_token_amount(uint256[4] calldata amounts, bool deposit)
        external
        returns (uint256 amount);

    function add_liquidity(uint256[4] calldata amounts, uint256 min_mint_amount)
        external;

    function get_dy(
        int128 sellTokenId,
        int128 buyTokenId,
        uint256 sellTokenAmt
    ) external returns (uint256 buyTokenAmt);

    function exchange(
        int128 sellTokenId,
        int128 buyTokenId,
        uint256 sellTokenAmt,
        uint256 minBuyToken
    ) external;

    function remove_liquidity_imbalance(
        uint256[4] calldata amounts,
        uint256 max_burn_amount
    ) external;
}
