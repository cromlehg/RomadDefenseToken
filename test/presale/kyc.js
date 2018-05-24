import ether from '../helpers/ether';
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
    this.price = 6667;
    this.softcap = ether(1000);
    this.minInvestedLimit = ether(0.1);

    token = await Token.new();
    crowdsale = await Crowdsale.new();
    await crowdsale.setPrice(ether(this.price));
    await crowdsale.setSoftcap(this.softcap);
    await crowdsale.setStart(this.start);
    await crowdsale.addMilestone(this.duration, 0, 0);
    await crowdsale.setMinInvestedLimit(this.minInvestedLimit);
    await crowdsale.setWallet(wallets[2]);
    await crowdsale.setToken(token.address);
    await crowdsale.transferOwnership(wallets[1]);
    await token.setSaleAgent(crowdsale.address);
    await token.transferOwnership(wallets[1]);
  });

  it('should add to KYCPending list before approving and delete after approving', async function () {
    await crowdsale.sendTransaction({value: ether(1), from: wallets[3]});
    assert.equal(await token.KYCPending(wallets[3]), true);
    await crowdsale.approveCustomer(wallets[3], {from: wallets[1]});
    assert.equal(await token.KYCPending(wallets[3]), false);
  });

  it('should auto approve', async function () {
    await crowdsale.switchKYCAutoApprove({from: wallets[1]});
    await crowdsale.sendTransaction({value: ether(1), from: wallets[4]});
    assert.equal(await token.KYCPending(wallets[4]), false);
    await crowdsale.switchKYCAutoApprove({from: wallets[1]});
    await crowdsale.sendTransaction({value: ether(1), from: wallets[5]});
    assert.equal(await token.KYCPending(wallets[5]), true);
  });

  it('should correctly summarize the investments', async function () {
    await crowdsale.sendTransaction({value: ether(11), from: wallets[3]}).should.be.fulfilled;
    await crowdsale.sendTransaction({value: ether(33), from: wallets[4]}).should.be.fulfilled;
    await crowdsale.sendTransaction({value: ether(13), from: wallets[3]}).should.be.fulfilled;
    await crowdsale.sendTransaction({value: ether(11), from: wallets[4]}).should.be.fulfilled;
    await crowdsale.sendTransaction({value: ether(199), from: wallets[3]}).should.be.fulfilled;
    await crowdsale.sendTransaction({value: ether(11), from: wallets[4]}).should.be.fulfilled;
    const balance1 = await crowdsale.balances(wallets[3]);
    const balance2 = await crowdsale.balances(wallets[4]);
    balance1.should.be.bignumber.equal(ether(11 + 13 + 199));
    balance2.should.be.bignumber.equal(ether(33 + 11 + 11));
  });

  it('should correctly summarize refunds', async function () {
    await crowdsale.sendTransaction({value: ether(11), from: wallets[3]}).should.be.fulfilled;
    await crowdsale.sendTransaction({value: ether(33), from: wallets[4]}).should.be.fulfilled;
    await crowdsale.sendTransaction({value: ether(13), from: wallets[3]}).should.be.fulfilled;
    await crowdsale.sendTransaction({value: ether(11), from: wallets[4]}).should.be.fulfilled;
    await crowdsale.sendTransaction({value: ether(199), from: wallets[3]}).should.be.fulfilled;
    await crowdsale.sendTransaction({value: ether(11), from: wallets[4]}).should.be.fulfilled;
    const balance1 = await crowdsale.balances(wallets[3]);
    const before1 = web3.eth.getBalance(wallets[3]);
    await crowdsale.refund({from: wallets[3], gasPrice: 0}).should.be.fulfilled;
    const after1 = web3.eth.getBalance(wallets[3]);
    after1.minus(before1).should.be.bignumber.equal(balance1);
    const balance2 = await crowdsale.balances(wallets[4]);
    const before2 = web3.eth.getBalance(wallets[4]);
    await crowdsale.refund({from: wallets[4], gasPrice: 0}).should.be.fulfilled;
    const after2 = web3.eth.getBalance(wallets[4]);
    after2.minus(before2).should.be.bignumber.equal(balance2);
  });

  it('should correctly calculate weiRaised and weiApproved', async function () {
    await crowdsale.sendTransaction({value: ether(11), from: wallets[3]}).should.be.fulfilled;
    await crowdsale.sendTransaction({value: ether(33), from: wallets[4]}).should.be.fulfilled;
    await crowdsale.sendTransaction({value: ether(199), from: wallets[5]}).should.be.fulfilled;
    await crowdsale.approveCustomer(wallets[5], {from: wallets[1]}).should.be.fulfilled;
    await crowdsale.sendTransaction({value: ether(19), from: wallets[5]}).should.be.fulfilled;
    await crowdsale.sendTransaction({value: ether(21), from: wallets[6]}).should.be.fulfilled;
    await crowdsale.refund({from: wallets[6]}).should.be.fulfilled;
    const raised = await crowdsale.weiRaised();
    raised.should.be.bignumber.equal(ether(11 + 33 + 199 + 19 + 21 - 21));
    const approved = await crowdsale.weiApproved();
    approved.should.be.bignumber.equal(ether(199 + 19));
  });

  it('should deny refunds for approved accounts', async function () {
    await crowdsale.sendTransaction({value: ether(11), from: wallets[3]});
    await crowdsale.approveCustomer(wallets[3], {from: wallets[1]});
    await crowdsale.sendTransaction({value: ether(33), from: wallets[3]});
    await crowdsale.refund({from: wallets[3]}).should.be.rejectedWith(EVMRevert);
  });

  it('should allow to refund only once', async function () {
    await crowdsale.sendTransaction({value: ether(11), from: wallets[3]});
    await crowdsale.sendTransaction({value: ether(33), from: wallets[3]});
    await crowdsale.refund({from: wallets[3]}).should.be.fulfilled;
    await crowdsale.refund({from: wallets[3]}).should.be.rejectedWith(EVMRevert);
  });

  it('should mint and burn tokens correctly for unapproved customers', async function () {
    await crowdsale.sendTransaction({value: ether(11), from: wallets[3]});
    await crowdsale.sendTransaction({value: ether(33), from: wallets[3]});
    await crowdsale.refund({from: wallets[3]}).should.be.fulfilled;
    const tokens = await token.balanceOf(wallets[3]);
    const totalSupply = await token.totalSupply();
    tokens.should.bignumber.equal(0);
    totalSupply.should.bignumber.equal(0);
  });

  it('should correctly add wallet to pendingList and remove from it after approvement', async function () {
    let pending = await token.KYCPending(wallets[3]);
    pending.should.equal(false);
    await crowdsale.sendTransaction({value: ether(11), from: wallets[3]});
    pending = await token.KYCPending(wallets[3]);
    pending.should.equal(true);
    await crowdsale.refund({from: wallets[3]}).should.be.fulfilled;
    pending = await token.KYCPending(wallets[3]);
    pending.should.equal(false);
    await crowdsale.sendTransaction({value: ether(11), from: wallets[3]});
    pending = await token.KYCPending(wallets[3]);
    pending.should.equal(true);
    await crowdsale.approveCustomer(wallets[3], {from: wallets[1]}).should.be.fulfilled;
    pending = await token.KYCPending(wallets[3]);
    pending.should.equal(false);
    await crowdsale.finish({from: wallets[1]}).should.be.fulfilled;
    await token.transfer(wallets[4], 1, {from: wallets[3]}).should.be.fulfilled;
    const balance = await token.balanceOf(wallets[4]);
    balance.should.bignumber.equal(1);
  });

  it('should correctly mint and burn tokens if customer was first unapproved, then make refund, then approved', async function () {
    await crowdsale.sendTransaction({value: ether(10), from: wallets[3]});
    await crowdsale.refund({from: wallets[3]}).should.be.fulfilled;
    await crowdsale.sendTransaction({value: ether(1), from: wallets[3]});
    await crowdsale.approveCustomer(wallets[3], {from: wallets[1]}).should.be.fulfilled;
    await crowdsale.refund({from: wallets[3]}).should.be.rejectedWith(EVMRevert);
    const balance = await token.balanceOf(wallets[3]);
    balance.should.bignumber.equal(this.price);
  });

}
