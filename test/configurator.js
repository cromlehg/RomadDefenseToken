import ether from './helpers/ether';
import tokens from './helpers/tokens';
import {advanceBlock} from './helpers/advanceToBlock';
import {increaseTimeTo, duration} from './helpers/increaseTime';
import latestTime from './helpers/latestTime';
import EVMRevert from './helpers/EVMRevert';

const should = require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(web3.BigNumber))
  .should();

const Configurator = artifacts.require('Configurator.sol');
const Token = artifacts.require('RobustCoin.sol');
const Presale = artifacts.require('Presale.sol');
const Mainsale = artifacts.require('Mainsale.sol');
const FoundersTokensWallet = artifacts.require('DoubleStageFreezeTokensWallet.sol');

contract('Configurator integration test', function (accounts) {
  let configurator;
  let token;
  let presale;
  let mainsale;
  let foundersTokensWallet;

  const manager = '0x675eDE27cafc8Bd07bFCDa6fEF6ac25031c74766';

  before(async function () {
    // Advance to the next block to correctly read time in the solidity "now" function interpreted by testrpc
    await advanceBlock();
    configurator = await Configurator.new();
    await configurator.deploy();

    const tokenAddress = await configurator.token();
    const presaleAddress = await configurator.presale();
    const mainsaleAddress = await configurator.mainsale();
    const foundersTokensWalletAddress = await configurator.foundersTokensWallet();

    token = await Token.at(tokenAddress);
    presale = await Presale.at(presaleAddress);
    mainsale = await Mainsale.at(mainsaleAddress);
    foundersTokensWallet = await FoundersTokensWallet.at(foundersTokensWalletAddress);
  });


  it('contracts should have token address', async function () {
    const tokenOwner = await token.owner();
    tokenOwner.should.bignumber.equal(manager);
  });

  it('contracts should have presale address', async function () {
    const presaleOwner = await presale.owner();
    presaleOwner.should.bignumber.equal(manager);
  });

  it('contracts should have mainsale address', async function () {
    const mainsaleOwner = await mainsale.owner();
    mainsaleOwner.should.bignumber.equal(manager);
  });

  it('contracts should have bounty wallet address', async function () {
    const foundersTokensWalletOwner = await foundersTokensWallet.owner();
    foundersTokensWalletOwner.should.bignumber.equal(manager);
  });

  it('presale and mainsale should have start time as described in README', async function () {
    const presaleStart = await presale.start();
    presaleStart.should.bignumber.equal((new Date('12 Feb 2018 00:00:00 GMT')).getTime() / 1000);
    const mainsaleStart = await mainsale.start();
    mainsaleStart.should.bignumber.equal((new Date('10 Mar 2018 00:00:00 GMT')).getTime() / 1000);
  });

  it ('presale period should be as described in README', async function () {
    const period = await presale.period();
    period.should.bignumber.equal(7);
  });

  it('bounty frizze wallet should have firstDate and secondDate time as described in README', async function () {
    const firstDate = await foundersTokensWallet.firstDate();
    firstDate.should.bignumber.equal((new Date('01 Dec 2018 00:00:00 GMT')).getTime() / 1000);
    const secondDate = await foundersTokensWallet.secondDate();
    secondDate.should.bignumber.equal((new Date('01 Sep 2019 00:00:00 GMT')).getTime() / 1000);
  });

  it ('presale and mainsale should have price as described in README', async function () {
    const presalePrice = await presale.price();
    presalePrice.should.bignumber.equal(tokens(6667));
    const mainsalePrice = await mainsale.price();
    mainsalePrice.should.bignumber.equal(tokens(5000));
  });

  it ('presale and mainsale should have hardcap as described in README', async function () {
    const presaleHardcap = await presale.hardcap();
    presaleHardcap.should.bignumber.equal(ether(11250));
    const mainsaleHardcap = await mainsale.hardcap();
    mainsaleHardcap.should.bignumber.equal(ether(47500));
  });

  it ('presale should have softcap as described in README', async function () {
    const presaleSoftcap = await presale.softcap();
    presaleSoftcap.should.bignumber.equal(ether(1000));
  });

  it ('presale and mainsale should have minimal insvested limit as described in README', async function () {
    const presaleMinInvest = await presale.minInvestedLimit();
    presaleMinInvest.should.bignumber.equal(ether(0.1));
    const mainsaleMinInvest = await mainsale.minInvestedLimit();
    mainsaleMinInvest.should.bignumber.equal(ether(0.1));
  });

  it ('founders wallet should have master percent as described in README', async function () {
    const masterPercent = await foundersTokensWallet.masterPercent();
    masterPercent.should.bignumber.equal(30);
  });

  it ('presale and mainsale should have wallets as described in README', async function () {
    const presaleWallet = await presale.wallet();
    presaleWallet.should.bignumber.equal('0xa86780383E35De330918D8e4195D671140A60A74');
    const mainsaleWallet = await mainsale.wallet();
    mainsaleWallet.should.bignumber.equal('0x98882D176234AEb736bbBDB173a8D24794A3b085');
  });

  it ('Bounty wallet and founders wallet should be as described in README', async function () {
    const foundersWallet = await foundersTokensWallet.wallet();
    foundersWallet.should.bignumber.equal('0x2AB0d2630eb67033E7D35eC1C43303a3F7720dA5');
    const bountyWallet = await mainsale.bountyTokensWallet();
    bountyWallet.should.bignumber.equal('0x28732f6dc12606D529a020b9ac04C9d6f881D3c5');
  });
});

