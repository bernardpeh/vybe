// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "../contracts/SafeMath.sol";
import "../contracts/Vybe.sol";
import "../contracts/VybeStake.sol";
import "../contracts/VybeLoan.sol";
import "../contracts/IVybeBorrower.sol";
import "@nomiclabs/buidler/console.sol";

contract VybeBorrower is IVybeBorrower {
  using SafeMath for uint256;

  Vybe private _VYBE;
  VybeStake private _stake;
  VybeLoan private _loan;
  uint256 private _remaining;
  uint256 private _staked;

  constructor(address vybe_address, address stake_address, address loan_address) {
    _VYBE = Vybe(vybe_address);
    _stake = VybeStake(stake_address);
    _loan = VybeLoan(loan_address);
  }

  function setupFlashLoan() public {

    _staked = _VYBE.balanceOf(address(this)) / 2;
    // this contract should already have some vybe
    // allow 250 vybe from this contract to be transferred
    _VYBE.approve(address(_stake), _staked);
    // transfer vybe to from this project to vybestake contract
    _stake.increaseStake(_staked);
  }

  function testFlashLoan() public {
    // setupFlashLoan();
    console.log('borrower: balance of staker: ',address(_stake), ' is ', _VYBE.balanceOf(address(_stake)));

   _loan.loan(_staked);
    // require(_VYBE.balanceOf(address(this)) == _remaining);
    // require(_VYBE.balanceOf(address(_stake)) == _staked);
    // require(_VYBE.totalSupply() == _staked.add(_remaining));

  }

  function loaned(uint256 amount, uint256 owed) override external {
    console.log('borrower: balance of VybeBorrower: ',address(this), ' is ', _VYBE.balanceOf(address(this)));
    console.log('borrower: total supply: ',_VYBE.totalSupply());
    // require(_VYBE.totalSupply() == _VYBE.balanceOf(address(this)));
    // require(amount == _staked);
    // require(owed == amount.add(amount.div(100)));
    _VYBE.approve(address(_loan), owed);
    console.log('borrower: amt owed: ',owed);

    _remaining = _VYBE.balanceOf(address(this)).sub(owed);
    console.log('borrower: remaining owed: ',_remaining);
  }
}
