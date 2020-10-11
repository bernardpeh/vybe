let VybeToken = artifacts.require("Vybe");
let VybeStake = artifacts.require("VybeStake");
let VybeLoan = artifacts.require("VybeLoan");
let VybeDAO = artifacts.require("VybeDAO");
let VybeBorrower = artifacts.require("VybeBorrower");
const BigNumber = require("bignumber.js");

module.exports = async (deployer) => {
  let VYBE = await deployer.deploy(VybeToken).chain;
  let stake = await deployer.deploy(VybeStake, VYBE.address);
  await VYBE.transferOwnership(stake.address);

  let loan = await deployer.deploy(VybeLoan, VYBE.address, stake.address);
  await stake.addMelody(loan.address);

  let vybeBorrower = await deployer.deploy(VybeBorrower, VYBE.address, stake.address, loan.address);
  await VYBE.transfer(vybeBorrower.address, new BigNumber("500"));

  let dao = await deployer.deploy(VybeDAO, stake.address);
  await stake.upgradeDevelopmentFund(dao.address);
  await stake.transferOwnership(dao.address);
};
