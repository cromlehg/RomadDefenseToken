pragma solidity 0.4.18;

import './ownership/Ownable.sol';
import './MintableToken.sol';
import './RobustCoin.sol';
import './Presale.sol';
import './Mainsale.sol';
import './DoubleStageFreezeTokensWallet.sol';

contract Configurator is Ownable {

  MintableToken public token;

  Presale public presale;

  Mainsale public mainsale;

  DoubleStageFreezeTokensWallet public bountyWallet;

  function deploy() public onlyOwner {
    //owner = 0x95EA6A4ec9F80436854702e5F05d238f27166A03;

    token = new RobustCoin();

    presale = new Presale();

    presale.setWallet(0x95EA6A4ec9F80436854702e5F05d238f27166A03);
    presale.setStart(1518393600);
    presale.setPeriod(7);
    presale.setPrice(6667000000000000000000);
    presale.setSoftcap(1000000000000000000000);
    presale.setMinInvestedLimit(10000000000000000);
    presale.setToken(token);
    presale.setHardcap(11250000000000000000000);
    token.setSaleAgent(presale);

    mainsale = new Mainsale();

    mainsale.addMilestone(6, 10);
    mainsale.addMilestone(6, 9);
    mainsale.addMilestone(6, 8);
    mainsale.addMilestone(6, 7);
    mainsale.addMilestone(6, 6);
    mainsale.addMilestone(6, 5);
    mainsale.addMilestone(6, 4);
    mainsale.addMilestone(6, 3);
    mainsale.addMilestone(6, 2);
    mainsale.addMilestone(3, 1);
    mainsale.addMilestone(3, 0);
    mainsale.setMinInvestedLimit(10000000000000000);
    mainsale.setToken(token);
    mainsale.setPrice(5000000000000000000000);
    mainsale.setWallet(0x95EA6A4ec9F80436854702e5F05d238f27166A03);
    mainsale.setFoundersTokensWallet(0x95EA6A4ec9F80436854702e5F05d238f27166A04);
    mainsale.setStart(1520640000);
    mainsale.setHardcap(47500000000000000000000);
    mainsale.setFoundersTokensPercent(10);
    mainsale.setBountyTokensPercent(5);

    bountyWallet = new DoubleStageFreezeTokensWallet();
    bountyWallet.setMasterPercent(30);
    bountyWallet.setWallet(0x95EA6A4ec9F80436854702e5F05d238f27166A04);
    bountyWallet.setToken(token);
    bountyWallet.setFirstDate(1543622400);
    bountyWallet.setSecondDate(1567296000);
    bountyWallet.activate();

    mainsale.setBountyTokensWallet(bountyWallet);

    presale.setNextSaleAgent(mainsale);

    bountyWallet.transferOwnership(owner);
    token.transferOwnership(owner);
    presale.transferOwnership(owner);
    mainsale.transferOwnership(owner);
  }

}

