const BigNumber = require("bignumber.js");
const VybeToken = artifacts.require("Vybe");
const VybeStake = artifacts.require("VybeStake");
const VybeLoan = artifacts.require("VybeLoan");
const VybeBorrower = artifacts.require("VybeBorrower");

const ONE = new BigNumber(1);
const DAY = 60 * 60 * 24;
const INITIAL = new BigNumber("2000000e18");

contract("Loan Test", async (accounts) => {
    it("Should setup borrower successfully", async () => {
        let borrower = await VybeBorrower.deployed();
        await borrower.setupFlashLoan();
        await borrower.testFlashLoan();
    });
});
