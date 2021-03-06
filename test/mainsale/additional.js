import ether from '../helpers/ether';
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
    this.duration = 60;
    this.end = this.start + duration.days(this.duration);
    this.afterEnd = this.end + duration.seconds(1);
    this.price = 5000;
    this.hardcap = ether(47500);
    this.minInvestedLimit = ether(0.1);

    token = await Token.new();
    crowdsale = await Crowdsale.new();
    await crowdsale.setPrice(ether(this.price));
    await crowdsale.setHardcap(this.hardcap);
    await crowdsale.setStart(this.start);
    await crowdsale.setMinInvestedLimit(this.minInvestedLimit);
    await crowdsale.setWallet(wallets[2]);
    await crowdsale.setToken(token.address);
    await crowdsale.addMilestone(6, 10, 0);
    await crowdsale.addMilestone(6, 9, 0);
    await crowdsale.addMilestone(6, 8, 0);
    await crowdsale.addMilestone(6, 7, 0);
    await crowdsale.addMilestone(6, 6, 0);
    await crowdsale.addMilestone(6, 5, 0);
    await crowdsale.addMilestone(6, 4, 0);
    await crowdsale.addMilestone(6, 3, 0);
    await crowdsale.addMilestone(6, 2, 0);
    await crowdsale.addMilestone(3, 1, 0);
    await crowdsale.addMilestone(3, 0, 0);
    await crowdsale.setTeamTokensWallet(wallets[3]);
    await crowdsale.setTeamTokensPercent(10);
    await crowdsale.setBountyTokensWallet(wallets[4]);
    await crowdsale.setBountyTokensPercent(5);
    await crowdsale.transferOwnership(wallets[1]);
    await token.setSaleAgent(crowdsale.address);
    await token.transferOwnership(wallets[1]);
  });

  it('should mintTokensExternal', async function () {
    await crowdsale.mintTokensExternal(wallets[4], 100, {from: wallets[1]}).should.be.fulfilled;
    const balance = await token.balanceOf(wallets[4]);
    balance.should.bignumber.equal(100);
  });

  it('should mintTokensByETHExternal', async function () {
    await crowdsale.mintTokensByETHExternal(wallets[5], ether(1), {from: wallets[1]}).should.be.fulfilled;
    const balance = await token.balanceOf(wallets[5]);
    balance.should.bignumber.equal(5500);
  });
}
