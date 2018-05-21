import ether from '../helpers/ether';
import tokens from '../helpers/tokens';
import {advanceBlock} from '../helpers/advanceToBlock';
import {duration} from '../helpers/increaseTime';
import latestTime from '../helpers/latestTime';

require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(web3.BigNumber))
  .should();

export default function (Token, Crowdsale, wallets) {
  let token;
  let crowdsale;

  before(async function () {
    // Advance to the next block to correctly read time in the solidity "now" function interpreted by testrpc
    await advanceBlock();
  });

  beforeEach(async function () {
    this.start = latestTime();
    this.duration = 7;
    this.end = this.start + duration.days(this.duration);
    this.afterEnd = this.end + duration.seconds(1);
    this.humanReadablePrice = 0.2; // 0.2 USD per token
    this.price = this.humanReadablePrice * 1000;
    this.humanReadableSoftcap = 5000000; // 5 000 000 USD
    this.softcap = this.humanReadableSoftcap * 1000;
    this.minInvestedLimit = ether(0.1);
    this.humanReadableETHtoUSD = 700; // 700 USD per ETH
    this.ETHtoUSD = this.humanReadableETHtoUSD * 1000;

    token = await Token.new();
    crowdsale = await Crowdsale.new();
    await crowdsale.setUSDPrice(this.price);
    await crowdsale.setUSDSoftcap(this.softcap);
    await crowdsale.setETHtoUSD(this.ETHtoUSD);
    await crowdsale.setStart(this.start);
    await crowdsale.addMilestone(this.duration, 0, 0);
    await crowdsale.setMinInvestedLimit(this.minInvestedLimit);
    await crowdsale.setWallet(wallets[2]);
    await crowdsale.setToken(token.address);
    await crowdsale.transferOwnership(wallets[1]);
    await token.setSaleAgent(crowdsale.address);
    await token.transferOwnership(wallets[1]);
  });

  it('should mintTokensExternal', async function () {
    await crowdsale.mintTokensExternal(wallets[4], tokens(100), {from: wallets[1]}).should.be.fulfilled;
    const balance = await token.balanceOf(wallets[4]);
    balance.should.bignumber.equal(100);
  });

  it('should mintTokensByETHExternal', async function () {
    await crowdsale.mintTokensByETHExternal(wallets[5], ether(1), {from: wallets[1]}).should.be.fulfilled;
    const balance = await token.balanceOf(wallets[5]);
    const price = this.ETHtoUSD * ether(1) / this.price;
    balance.should.bignumber.equal(price);
  });
}
