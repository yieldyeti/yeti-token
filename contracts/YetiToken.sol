//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract YetiToken is ERC20 {
    using SafeMath for uint256;

    string constant NAME = "YETI";
    string constant SYMBOL = "YETI";
    uint256 constant TOTAL_SUPPLY = 100000000;

    constructor() ERC20(NAME, SYMBOL) {
        _mint(msg.sender, TOTAL_SUPPLY * 10**uint256(decimals()));
    }
}
