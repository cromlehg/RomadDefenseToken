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
const Token = artifacts.require('RomadDefenseToken.sol');
const Presale = artifacts.require('PreICO.sol');
const Mainsale = artifacts.require('ICO.sol');
const TeamTokensWallet = artifacts.require('DoubleStageFreezeTokensWallet.sol');
const EarlyInvestorsTokensWallet = artifacts.require('DoubleStageFreezeTokensWallet.sol');

contract('Configurator integration test', function (accounts) {
  let configurator;
  let token;
  let presale;
  let mainsale;
  let teamTokensWallet;
  let earlyInvestorsTokensWallet;

  const manager = '0x675eDE27cafc8Bd07bFCDa6fEF6ac25031c74766';

  before(async function () {
    // Advance to the next block to correctly read time in the solidity "now" function interpreted by testrpc
    await advanceBlock();
    configurator = await Configurator.new();
    token = await Token.new();
    presale = await Presale.new();
    mainsale = await Mainsale.new();
    teamTokensWallet = await TeamTokensWallet.new();
    earlyInvestorsTokensWallet = await EarlyInvestorsTokensWallet.new();

    await token.transferOwnership(configurator.address);
    await presale.transferOwnership(configurator.address);
    await mainsale.transferOwnership(configurator.address);
    await teamTokensWallet.transferOwnership(configurator.address);
    await earlyInvestorsTokensWallet.transferOwnership(configurator.address);

    await configurator.setToken(token.address);
    await configurator.setPreICO(presale.address);
    await configurator.setICO(mainsale.address);
    await configurator.setTeamTokensWallet(teamTokensWallet.address);
    await configurator.setEarlyInvestorsTokensWallet(earlyInvestorsTokensWallet.address);
    await configurator.deploy();
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

  it('contracts should have team wallet address', async function () {
    const teamTokensWalletOwner = await teamTokensWallet.owner();
    teamTokensWalletOwner.should.bignumber.equal(manager);
  });

  it('contracts should have earlyInvestorsTokens wallet address', async function () {
    const earlyInvestorsTokensWalletOwner = await earlyInvestorsTokensWallet.owner();
    earlyInvestorsTokensWalletOwner.should.bignumber.equal(manager);
  });

  it('presale and mainsale should have start time as described in README', async function () {
    const presaleStart = await presale.start();
    presaleStart.should.bignumber.equal((new Date('27 Jun 2018 17:00:00 GMT')).getTime() / 1000);
    const mainsaleStart = await mainsale.start();
    mainsaleStart.should.bignumber.equal((new Date('25 Jul 2018 17:00:00 GMT')).getTime() / 1000);
  });

  it('bounty frizze wallet should have firstDate and secondDate time as described in README', async function () {
    const firstDate = await teamTokensWallet.firstDate();
    firstDate.should.bignumber.equal((new Date('01 Dec 2018 00:00:00 GMT')).getTime() / 1000);
    const secondDate = await teamTokensWallet.secondDate();
    secondDate.should.bignumber.equal((new Date('01 Sep 2019 00:00:00 GMT')).getTime() / 1000);
  });

  it ('presale and mainsale should have minimal insvested limit as described in README', async function () {
    const presaleMinInvest = await presale.minInvestedLimit();
    presaleMinInvest.should.bignumber.equal(ether(0.1));
    const mainsaleMinInvest = await mainsale.minInvestedLimit();
    mainsaleMinInvest.should.bignumber.equal(ether(0.1));
  });

  it ('founders wallet should have master percent as described in README', async function () {
    const masterPercent = await teamTokensWallet.masterPercent();
    masterPercent.should.bignumber.equal(30);
  });

  it ('presale and mainsale should have wallets as described in README', async function () {
    const presaleWallet = await presale.wallet();
    presaleWallet.should.bignumber.equal('0xa86780383E35De330918D8e4195D671140A60A74');
    const mainsaleWallet = await mainsale.wallet();
    mainsaleWallet.should.bignumber.equal('0x98882D176234AEb736bbBDB173a8D24794A3b085');
  });

  it ('Bounty wallet and founders wallet should be as described in README', async function () {
    const foundersWallet = await teamTokensWallet.wallet();
    foundersWallet.should.bignumber.equal('0x2AB0d2630eb67033E7D35eC1C43303a3F7720dA5');
    const bountyWallet = await mainsale.bountyTokensWallet();
    bountyWallet.should.bignumber.equal('0x28732f6dc12606D529a020b9ac04C9d6f881D3c5');
  });
});

