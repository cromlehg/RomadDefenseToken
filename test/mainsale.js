import capped from './mainsale/capped';
import common from './mainsale/common';
import milestonebonus from './mainsale/milestonebonus';
import bounty from './mainsale/bounty';
import additional from './mainsale/additional';

const token = artifacts.require('SafetyToken.sol');
const crowdsale = artifacts.require('ICO.sol');

contract('Mainsale - common test', function (accounts) {
  common(token, crowdsale, accounts);
});

contract('Mainsale - capped crowdsale test', function (accounts) {
  capped(token, crowdsale, accounts);
});

contract('Mainsale - milestone bonus test', function (accounts) {
  milestonebonus(token, crowdsale, accounts);
});


contract('Mainsale - bounty test', function (accounts) {
  bounty(token, crowdsale, accounts);
});

contract('Mainsale - additional features test', function (accounts) {
  additional(token, crowdsale, accounts);
});
