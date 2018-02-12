pragma solidity ^0.4.18;

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

    token = new RobustCoin();

    presale = new Presale();

    presale.setWallet(0xa86780383E35De330918D8e4195D671140A60A74);
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
    mainsale.setWallet(0x98882D176234AEb736bbBDB173a8D24794A3b085);
    mainsale.setFoundersTokensWallet(0x2AB0d2630eb67033E7D35eC1C43303a3F7720dA5);
    mainsale.setStart(1520640000);
    mainsale.setHardcap(47500000000000000000000);
    mainsale.setFoundersTokensPercent(10);
    mainsale.setBountyTokensPercent(5);

    bountyWallet = new DoubleStageFreezeTokensWallet();
    bountyWallet.setMasterPercent(30);
    bountyWallet.setWallet(0x28732f6dc12606D529a020b9ac04C9d6f881D3c5);
    bountyWallet.setToken(token);
    bountyWallet.setFirstDate(1543622400);
    bountyWallet.setSecondDate(1567296000);
    bountyWallet.activate();

    mainsale.setBountyTokensWallet(bountyWallet);

    presale.setNextSaleAgent(mainsale);

    address manager = 0x675eDE27cafc8Bd07bFCDa6fEF6ac25031c74766;

    bountyWallet.transferOwnership(manager);
    token.transferOwnership(manager);
    presale.transferOwnership(manager);
    mainsale.transferOwnership(manager);
  }

}

