import additional from './token/additional';
import basic from './token/basic';
import mintable from './token/mintable';
import ownable from './token/ownable';
import standard from './token/standard';

const token = artifacts.require('RobustCoin.sol');

contract('Basic Token', function (accounts) {
  describe('Basic Token', function () {
    basic(token, accounts);
  });
  describe('Standard Token', function () {
    standard(token, accounts);
  });
  describe('Mintable Token', function () {
    mintable(token, accounts);
  });
  describe('Ownable Token', function () {
    ownable(token, accounts);
  });
  describe('Additional conditions', function () {
    additional(token, accounts);
  });
});
