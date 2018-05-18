import ether from '../helpers/ether';
import tokens from '../helpers/tokens';
import {advanceBlock} from '../helpers/advanceToBlock';
import {increaseTimeTo, duration} from '../helpers/increaseTime';
import latestTime from '../helpers/latestTime';
import EVMRevert from '../helpers/EVMRevert';

require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(web3.BigNumber))
  .should();

export default function (Token, Crowdsale, wallets) {
  let token;
  let crowdsale;
  const milestones = [
    {day: 0, bonus: 20},
    {day: 1, bonus: 18},
    {day: 3, bonus: 16},
    {day: 7, bonus: 15},
    {day: 10, bonus: 14},
    {day: 13, bonus: 13},
    {day: 16, bonus: 12},
    {day: 19, bonus: 11}
  ];

  before(async function () {
    // Advance to the next block to correctly read time in the solidity "now" function interpreted by testrpc
    await advanceBlock();
  });

  beforeEach(async function () {
    this.start = latestTime();
    this.duration = 21;
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
    await crowdsale.addMilestone(1, 20, 10000000000000000000);
    await crowdsale.addMilestone(2, 18, 5000000000000000000);
    await crowdsale.addMilestone(4, 16, 1000000000000000000);
    await crowdsale.addMilestone(3, 15, 0);
    await crowdsale.addMilestone(3, 14, 0);
    await crowdsale.addMilestone(3, 13, 0);
    await crowdsale.addMilestone(3, 12, 0);
    await crowdsale.addMilestone(3, 11, 0);
    await crowdsale.transferOwnership(wallets[1]);
    await token.setSaleAgent(crowdsale.address);
    await token.transferOwnership(wallets[1]);
  });

  milestones.forEach((milestone, i) => {
    const {day, bonus} = milestone;
    it(`should add ${bonus}% bonus for milestone #${i}, day #${day}`, async function () {
      if (milestone.day !== 0) {
        await increaseTimeTo(this.start + duration.days(milestone.day));
      }
      const investment = 20;
      await crowdsale.sendTransaction({value: ether(investment), from: wallets[i]});
      const balance = await token.balanceOf(wallets[i]);
      const value = this.price.times(investment + investment * milestone.bonus / 100);
      balance.should.be.bignumber.equal(value);
    });
  });

  it('should reject transactions below milestone`s min investment limit ', async function () {
    await crowdsale.sendTransaction({value: ether(1), from: wallets[4]}).should.be.rejectedWith(EVMRevert);
    await crowdsale.sendTransaction({value: ether(20), from: wallets[4]}).should.be.fulfilled;
    await increaseTimeTo(this.start + duration.days(1));
    await crowdsale.sendTransaction({value: ether(1), from: wallets[4]}).should.be.rejectedWith(EVMRevert);
    await crowdsale.sendTransaction({value: ether(5), from: wallets[4]}).should.be.fulfilled;
    await increaseTimeTo(this.start + duration.days(3));
    await crowdsale.sendTransaction({value: ether(0.9), from: wallets[4]}).should.be.rejectedWith(EVMRevert);
    await crowdsale.sendTransaction({value: ether(1), from: wallets[4]}).should.be.fulfilled;
  });

  it('should always reject transactions below global min investment limit', async function () {
    await increaseTimeTo(this.start + duration.days(7));
    await crowdsale.sendTransaction({value: ether(0.09), from: wallets[4]}).should.be.rejectedWith(EVMRevert);
    await crowdsale.sendTransaction({value: ether(0.1), from: wallets[4]}).should.be.fulfilled;
  });
}
