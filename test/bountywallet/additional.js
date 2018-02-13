import ether from '../helpers/ether';
import tokens from '../helpers/tokens';
import {advanceBlock} from '../helpers/advanceToBlock';
import {duration} from '../helpers/increaseTime';
import latestTime from '../helpers/latestTime';

require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(web3.BigNumber))
  .should();

export default function (Token, BountyWallet, wallets) {
  let token;
  let bountywallet;

  before(async function () {
    // Advance to the next block to correctly read time in the solidity "now" function interpreted by testrpc
    await advanceBlock();
  });

  beforeEach(async function () {
    this.firstDate = latestTime() - duration.days(1);
    this.secondDate = latestTime() + duration.days(1);
    this.masterPercent = 30;

    token = await Token.new();
    bountywallet = await BountyWallet.new();

    await bountywallet.setFirstDate(this.firstDate);
    await bountywallet.setSecondDate(this.secondDate);
    await bountywallet.setMasterPercent(this.masterPercent);
    await bountywallet.setWallet(wallets[2]);
    await bountywallet.setToken(token.address);
    await bountywallet.transferOwnership(wallets[1]);
    await token.transferOwnership(wallets[1]);
  });

  it('should withdraw', async function () {
    await token.mint(bountywallet.address, 100, {from: wallets[1]});
    await token.finishMinting({from: wallets[1]});
    await bountywallet.activate({from: wallets[1]});
    await bountywallet.withdraw({from: wallets[1]});
  });
}
