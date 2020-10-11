// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "./SafeMath.sol";
import "./ReentrancyGuard.sol";
import "./Ownable.sol";
import "./Vybe.sol";
import "./IVybeBorrower.sol";
import "@nomiclabs/buidler/console.sol";

contract VybeLoan is ReentrancyGuard, Ownable {
  using SafeMath for uint256;

  Vybe private _VYBE;
  uint256 internal _feeDivisor = 100;

  event Loaned(uint256 amount, uint256 profit);

  constructor(address VYBE, address vybeStake) Ownable(vybeStake) {
    _VYBE = Vybe(VYBE);
  }

  // loan out VYBE from the staked funds
  function loan(uint256 amount) external noReentrancy {
    // set a profit of 1%
    uint256 profit = amount.div(_feeDivisor);
    uint256 owed = amount.add(profit);
    console.log('loan: amt loan is ',amount);
    console.log('loan: profit is ',profit);
    console.log('loan: owe is ', owed);
    // transfer the funds 125 from staker to borwwower
    require(_VYBE.transferFrom(owner(), msg.sender, amount));

    // approve owed to loan contract
    IVybeBorrower(msg.sender).loaned(amount, owed);

    // transfer back to the staking pool

    console.log('loan1: balance of staker: ',address(owner()), ' is ', _VYBE.balanceOf(owner()));
    console.log('loan1: balance of VybeBorrower: ',address(msg.sender), ' is ', _VYBE.balanceOf(address(msg.sender)));
    console.log('loan1: balance of VybeLoan: ',address(this), ' is ', _VYBE.balanceOf(address(this)));

    require(_VYBE.transferFrom(msg.sender, owner(), amount));
    // take the profit
    console.log('loan2: balance of staker: ',address(owner()), ' is ', _VYBE.balanceOf(owner()));
    console.log('loan2: balance of VybeBorrower: ',address(msg.sender), ' is ', _VYBE.balanceOf(address(msg.sender)));
    console.log('loan2: balance of VybeLoan: ',address(this), ' is ', _VYBE.balanceOf(address(this)));

    require(_VYBE.transferFrom(msg.sender, address(this), profit));
    // burn it, distributing its value to the ecosystem
    require(_VYBE.burn(profit));
    console.log('loan3: total supply:',_VYBE.totalSupply());
    console.log('loan3: balance of staker: ',address(msg.sender), ' is ', _VYBE.balanceOf(address(msg.sender)));
    console.log('loan3: balance of VybeBorrower: ',address(msg.sender), ' is ', _VYBE.balanceOf(address(msg.sender)));
    console.log('loan3: balance of VybeLoan: ',address(this), ' is ', _VYBE.balanceOf(address(this)));


  emit Loaned(amount, profit);
  }
}
