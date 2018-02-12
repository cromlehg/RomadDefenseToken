import ether from '../helpers/ether';
import tokens from '../helpers/tokens';
import {advanceBlock} from '../helpers/advanceToBlock';
import {increaseTimeTo, duration} from '../helpers/increaseTime';
import latestTime from '../helpers/latestTime';

require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(web3.BigNumber))
  .should();

export default function (Token, Crowdsale, wallets) {
  let token;
  let crowdsale;
  const milestones = [
    {day: 0, bonus: 10},
    {day: 6, bonus: 9},
    {day: 12, bonus: 8},
    {day: 18, bonus: 7},
    {day: 24, bonus: 6},
    {day: 30, bonus: 5},
    {day: 36, bonus: 4},
    {day: 42, bonus: 3},
    {day: 48, bonus: 2},
    {day: 54, bonus: 1},
    {day: 57, bonus: 0}
  ];

  before(async function () {
    // Advance to the next block to correctly read time in the solidity "now" function interpreted by testrpc
    await advanceBlock();
  });

  beforeEach(async function () {
    this.start = latestTime();	
    this.duration = 60;
    this.end = this.start + duration.days(this.duration);
    this.afterEnd = this.end + duration.seconds(1);
    this.price = tokens(5000);
    this.hardcap = ether(47500);
    this.minInvestedLimit = ether(0.1);

    token = await Token.new();
    crowdsale = await Crowdsale.new();
    await crowdsale.setPrice(this.price);
    await crowdsale.setHardcap(this.hardcap);
    await crowdsale.setStart(this.start);
    await crowdsale.setMinInvestedLimit(this.minInvestedLimit);
    await crowdsale.setWallet(wallets[2]);
    await crowdsale.setToken(token.address);
    await crowdsale.addMilestone(6, 10);
    await crowdsale.addMilestone(6, 9);
    await crowdsale.addMilestone(6, 8);
    await crowdsale.addMilestone(6, 7);
    await crowdsale.addMilestone(6, 6);
    await crowdsale.addMilestone(6, 5);
    await crowdsale.addMilestone(6, 4);
    await crowdsale.addMilestone(6, 3);
    await crowdsale.addMilestone(6, 2);
    await crowdsale.addMilestone(3, 1);
    await crowdsale.addMilestone(3, 0);
    await crowdsale.setFoundersTokensWallet(wallets[3]);
    await crowdsale.setFoundersTokensPercent(10);
    await crowdsale.setBountyTokensWallet(wallets[4]);
    await crowdsale.setBountyTokensPercent(5);
    await crowdsale.transferOwnership(wallets[1]);
    await token.setSaleAgent(crowdsale.address);
    await token.transferOwnership(wallets[1]);
  });

  milestones.forEach((milestone, i) => {
    if (i < 10){
      it(`should add ${milestone.bonus}% bonus for milestone #${i}`, async function () {
        if (milestone.day !== 0) {
          await increaseTimeTo(this.start + duration.days(milestone.day));
        }
        await crowdsale.sendTransaction({value: ether(1), from: wallets[i]});
        const balance = await token.balanceOf(wallets[i]);
        const value = this.price.times(1 + milestone.bonus / 100);
        balance.should.be.bignumber.equal(value);
      });
    }
  });

  it('should not add bonus for milestone #10', async function () {
    await increaseTimeTo(this.start + duration.days(57));
    await crowdsale.sendTransaction({value: ether(1), from: wallets[1]});
    const balance = await token.balanceOf(wallets[1]);
    const value = this.price.times(1);
    balance.should.be.bignumber.equal(value);
  });
}
