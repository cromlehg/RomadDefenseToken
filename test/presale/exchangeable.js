import ether from '../helpers/ether';
import tokens from '../helpers/tokens';
import {advanceBlock} from '../helpers/advanceToBlock';
import {increaseTimeTo, duration} from '../helpers/increaseTime';
import latestTime from '../helpers/latestTime';
import EVMRevert from '../helpers/EVMRevert';

const chai = require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(web3.BigNumber));
chai.should();

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
    this.humanReadableHardcap = 28000000; // 28 000 000 USD
    this.hardcap = this.humanReadableHardcap * 1000;
    this.minInvestedLimit = ether(10);
    this.humanReadableETHtoUSD = 700; // 700 USD per ETH
    this.ETHtoUSD = this.humanReadableETHtoUSD * 1000;

    token = await Token.new();
    crowdsale = await Crowdsale.new();
    await crowdsale.setUSDPrice(this.price);
    await crowdsale.setUSDSoftcap(this.softcap);
    await crowdsale.setUSDHardcap(this.hardcap);
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

  it('should set price, softcap and hardcap correctyly', async function () {
    const softcap = await crowdsale.softcap();
    const hardcap = await crowdsale.hardcap();
    const price = await crowdsale.price();
    softcap.toPrecision(15).should.bignumber.equal(ether(this.softcap / this.ETHtoUSD).toPrecision(15));
    hardcap.toPrecision(15).should.bignumber.equal(ether(this.hardcap / this.ETHtoUSD).toPrecision(15));
    price.toPrecision(15).should.bignumber.equal(ether(this.ETHtoUSD / this.price).toPrecision(15));
  });

  it('should recalculate price, softcap and hardcap correctyly', async function () {
    const rate = 95000;
    await crowdsale.setETHtoUSD(rate, {from: wallets[1]});
    const softcap = await crowdsale.softcap();
    const hardcap = await crowdsale.hardcap();
    const price = await crowdsale.price();
    softcap.toPrecision(15).should.bignumber.equal(ether(this.softcap / rate).toPrecision(15));
    hardcap.toPrecision(15).should.bignumber.equal(ether(this.hardcap / rate).toPrecision(15));
    price.toPrecision(15).should.bignumber.equal(ether(rate / this.price).toPrecision(15));
  });

  it('should mint corect amount of tokens depending on USD price', async function () {
    await crowdsale.setETHtoUSD(this.ETHtoUSD, {from: wallets[1]});
    const investment = 11;
    const conversionRate = this.humanReadableETHtoUSD;
    const price = this.humanReadablePrice;
    await crowdsale.sendTransaction({value: ether(investment), from: wallets[3]});
    const balance = await token.balanceOf(wallets[3]);
    balance.should.be.bignumber.equal(ether(investment * conversionRate / price));
  });

  it('should reject payments outside hardcap', async function () {
    const investment = this.humanReadableHardcap / this.humanReadableETHtoUSD;
    await crowdsale.sendTransaction({value: ether(investment), from: wallets[5]}).should.be.fulfilled;
    await crowdsale.sendTransaction({value: ether(11), from: wallets[4]}).should.be.rejectedWith(EVMRevert);
  });

  it('should allow refunds after end if goal was not reached', async function () {
    const investment = ether(this.humanReadableSoftcap / this.humanReadableETHtoUSD).minus(ether(1));
    await crowdsale.sendTransaction({value: investment, from: wallets[3]});
    await increaseTimeTo(this.afterEnd);
    await crowdsale.finish({from: wallets[1]});
    const balance = await crowdsale.balances(wallets[3]);
    balance.should.be.bignumber.equal(investment);
    const pre = web3.eth.getBalance(wallets[3]);
    await crowdsale.refund({from: wallets[3], gasPrice: 0}).should.be.fulfilled;
    const post = web3.eth.getBalance(wallets[3]);
    post.minus(pre).should.be.bignumber.equal(investment);
  });

}
