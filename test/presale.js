import common from './presale/common';
import capped from './presale/capped';
import refundable from './presale/refundable';
import additional from './presale/additional';

const token = artifacts.require('RomadDefenseToken.sol');
const crowdsale = artifacts.require('PreICO.sol');

contract('Presale - common crowdsale test', function (accounts) {
  common(token, crowdsale, accounts);
});

contract('Presale - capped crowdsale test', function (accounts) {
  capped(token, crowdsale, accounts);
});

contract('Presale - refundable crowdsale test', function (accounts) {
  refundable(token, crowdsale, accounts);
});

contract('Presale - additional features test', function (accounts) {
  additional(token, crowdsale, accounts);
});
