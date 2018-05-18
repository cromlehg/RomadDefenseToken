import common from './presale/common';
import milestonebonus from './presale/milestonebonus';
import refundable from './presale/refundable';
import additional from './presale/additional';
import exchangeable from './presale/exchangeable';

const token = artifacts.require('RomadDefenseToken.sol');
const crowdsale = artifacts.require('PreICO.sol');

contract('Presale - common crowdsale test', function (accounts) {
  common(token, crowdsale, accounts);
});

contract('Presale - milestone bonus test', function (accounts) {
  milestonebonus(token, crowdsale, accounts);
});

contract('Presale - refundable crowdsale test', function (accounts) {
  refundable(token, crowdsale, accounts);
});

contract('Presale - additional features test', function (accounts) {
  additional(token, crowdsale, accounts);
});

contract('Presale - USD exchange features test', function (accounts) {
  exchangeable(token, crowdsale, accounts);
});
