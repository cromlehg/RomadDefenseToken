import ether from '../helpers/ether';
import tokens from '../helpers/tokens';
import {advanceBlock} from '../helpers/advanceToBlock';
import {duration, increaseTimeTo} from '../helpers/increaseTime';
import latestTime from '../helpers/latestTime';

require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(web3.BigNumber))
  .should();

export default function (Token, FoundersWallet, wallets) {
  let token;
  let foundersWallet;

  before(async function () {
    // Advance to the next block to correctly read time in the solidity "now" function interpreted by testrpc
    await advanceBlock();
  });

  beforeEach(async function () {
    this.firstDate = latestTime() + duration.days(1);
    this.secondDate = latestTime() + duration.days(2);
    this.masterPercent = 30;
    this.slavePercent = 70;

    token = await Token.new();
    foundersWallet = await FoundersWallet.new();

    await foundersWallet.setFirstDate(this.firstDate);
    await foundersWallet.setSecondDate(this.secondDate);
    await foundersWallet.setMasterPercent(this.masterPercent);
    await foundersWallet.setWallet(wallets[2]);
    await foundersWallet.setToken(token.address);
    await foundersWallet.transferOwnership(wallets[1]);
    await token.transferOwnership(wallets[1]);
  });

  it('should withdraw', async function () {
    await token.mint(foundersWallet.address, 100, {from: wallets[1]});
    await token.finishMinting({from: wallets[1]});
    await foundersWallet.activate({from: wallets[1]});
    await foundersWallet.withdraw({from: wallets[1]});
  });

  it('should correctly calculate percentage', async function () {
    const investment = tokens(100);
    await token.mint(foundersWallet.address, investment, {from: wallets[1]});
    await token.finishMinting({from: wallets[1]});
    await foundersWallet.activate({from: wallets[1]});
    const amount = await token.balanceOf(foundersWallet.address);

    await increaseTimeTo(this.firstDate + duration.seconds(1));
    await foundersWallet.withdraw({from: wallets[1]});
    const firstTranche = await token.balanceOf(wallets[2]);
    firstTranche.should.bignumber.equal(amount.times(this.masterPercent / 100));

    await increaseTimeTo(this.secondDate + duration.seconds(1));
    await foundersWallet.setWallet(wallets[3], {from: wallets[1]});
    await foundersWallet.withdraw({from: wallets[1]});
    const secondTranche = await token.balanceOf(wallets[3]);
    secondTranche.should.bignumber.equal(amount.times(this.slavePercent / 100));
  });

  it('should return 0 tokens before fist milestone', async function () {
    const investment = tokens(100);
    await token.mint(foundersWallet.address, investment, {from: wallets[1]});
    await token.finishMinting({from: wallets[1]});
    await foundersWallet.activate({from: wallets[1]});
    const prematureTranche = await token.balanceOf(wallets[2]);
    prematureTranche.should.bignumber.equal(0);
  });
}
