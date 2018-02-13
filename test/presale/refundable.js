import ether from '../helpers/ether';
import tokens from '../helpers/tokens';
import { advanceBlock } from '../helpers/advanceToBlock';
import { increaseTimeTo, duration } from '../helpers/increaseTime';
import latestTime from '../helpers/latestTime';
import EVMRevert from '../helpers/EVMRevert';

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
    this.price = tokens(6667);
    this.softcap = ether(1000);
    this.hardcap = ether(11250);
    this.minInvestedLimit = ether(0.1);

    token = await Token.new();
    crowdsale = await Crowdsale.new();
    await crowdsale.setPrice(this.price);
    await crowdsale.setSoftcap(this.softcap);
    await crowdsale.setHardcap(this.hardcap);
    await crowdsale.setStart(this.start);
    await crowdsale.setPeriod(this.duration);
    await crowdsale.setMinInvestedLimit(this.minInvestedLimit);
    await crowdsale.setWallet(wallets[2]);
    await crowdsale.setToken(token.address);
    await crowdsale.transferOwnership(wallets[1]);
    await token.setSaleAgent(crowdsale.address);
    await token.transferOwnership(wallets[1]);
  });

  it('should deny refunds before end', async function () {
    await crowdsale.sendTransaction({value: ether(1), from: wallets[3]});
    await crowdsale.refund({from: wallets[3]}).should.be.rejectedWith(EVMRevert);
  });

  it('should deny refunds after end if goal was reached', async function () {
    await crowdsale.sendTransaction({value: this.softcap, from: wallets[3]});
    await increaseTimeTo(this.afterEnd);
    await crowdsale.refund({from: wallets[3]}).should.be.rejectedWith(EVMRevert);
  });

  it('should allow refunds after end if goal was not reached', async function () {
    const investment = this.softcap.minus(1);
    await crowdsale.sendTransaction({value: investment, from: wallets[3]});
    await increaseTimeTo(this.afterEnd);
    await crowdsale.finish({from: wallets[1]});
    const pre = web3.eth.getBalance(wallets[3]);
    await crowdsale.refund({from: wallets[3], gasPrice: 0}).should.be.fulfilled;
    const post = web3.eth.getBalance(wallets[3]);
    post.minus(pre).should.be.bignumber.equal(investment);
  });

  it('should correctly calculate refund', async function () {
    const investment1 = ether(1);
    const investment2 = ether(2);
    await crowdsale.sendTransaction({value: investment1, from: wallets[3]});
    await crowdsale.sendTransaction({value: investment2, from: wallets[3]});
    await increaseTimeTo(this.afterEnd);
    await crowdsale.finish({from: wallets[1]});
    const pre = web3.eth.getBalance(wallets[3]);
    await crowdsale.refund({from: wallets[3], gasPrice: 0}).should.be.fulfilled;
    const post = web3.eth.getBalance(wallets[3]);
    post.minus(pre).should.bignumber.equal(investment1.plus(investment2));
  });

  it('should forward funds to wallet after end if goal was reached', async function () {
    const investment = this.softcap;
    await crowdsale.sendTransaction({value: investment, from: wallets[3]});
    await increaseTimeTo(this.afterEnd);
    const pre = web3.eth.getBalance(wallets[2]);
    await crowdsale.finish({from: wallets[1]}).should.be.fulfilled;
    const post = web3.eth.getBalance(wallets[2]);
    post.minus(pre).should.be.bignumber.equal(investment);
  });
}
