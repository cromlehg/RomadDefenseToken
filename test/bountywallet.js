import additional from './bountywallet/additional';
import ownable from './bountywallet/ownable';

const token = artifacts.require('RobustCoin.sol');
const bountywallet = artifacts.require('DoubleStageFreezeTokensWallet.sol');

contract('Bounty Wallet is ownable', function (accounts) {
  ownable(bountywallet, accounts);
});

contract('Bounty - test for additional functional', function (accounts) {
  additional(token, bountywallet, accounts);
});
