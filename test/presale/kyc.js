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
    this.minInvestedLimit = ether(0.1);

    token = await Token.new();
    crowdsale = await Crowdsale.new();
    await crowdsale.setPrice(this.price);
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
}
