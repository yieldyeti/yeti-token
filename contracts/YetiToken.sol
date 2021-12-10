//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract YetiToken is ERC20 {
  using SafeMath for uint256;
  
  string constant NAME = "YETI";
  string constant SYMBOL = "YETI";
  uint256 TOTAL_SUPPLY = 10000000;

  mapping(address => uint256) balances;
  mapping(address => mapping (address => uint256)) allowed;

  constructor() ERC20(NAME, SYMBOL) {
    balances[msg.sender] = TOTAL_SUPPLY;
  }

  function totalSupply() override public view returns (uint256) {
    return TOTAL_SUPPLY;
  }

  function balanceOf(address owner) override public view returns (uint) {
    return balances[owner];
  }

  function transfer(address receiver, uint tokensAmount) override public returns (bool) {
    require(tokensAmount <= balances[msg.sender]);
    balances[msg.sender] = balances[msg.sender].sub(tokensAmount);
    balances[receiver] = balances[receiver].add(tokensAmount);
    emit Transfer(msg.sender, receiver, tokensAmount);
    return true;
  }

  function approve(address delegate, uint amount) override public returns (bool) {
    allowed[msg.sender][delegate] = amount;
    emit Approval(msg.sender, delegate, amount);
    return true;
  }

  function allowance(address owner, address delegate) override public view returns (uint) {
    return allowed[owner][delegate];
  }
}