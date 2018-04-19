import additional from './founderswallet/additional';
import ownable from './founderswallet/ownable';

const token = artifacts.require('RomadDefenseToken.sol');
const foundersWallet = artifacts.require('DoubleStageFreezeTokensWallet.sol');

contract('Bounty Wallet is ownable', function (accounts) {
  ownable(foundersWallet, accounts);
});

contract('Bounty - test for additional functional', function (accounts) {
  additional(token, foundersWallet, accounts);
});
