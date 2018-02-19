pragma solidity ^0.4.18;

import './ownership/Ownable.sol';
import './MintableToken.sol';
import './SafetyToken.sol';
import './PreICO.sol';
import './ICO.sol';
import './DoubleStageFreezeTokensWallet.sol';

contract Configurator is Ownable {

  MintableToken public token;

  PreICO public preICO;

  ICO public ico;

  DoubleStageFreezeTokensWallet public teamTokensWallet;

  function deploy() public onlyOwner {

    token = new SafetyToken();

    preICO = new PreICO();

    preICO.setWallet(0xa86780383E35De330918D8e4195D671140A60A74);
    preICO.setStart(1518393600);
    preICO.setPeriod(7);
    preICO.setPrice(6667000000000000000000);
    preICO.setSoftcap(1000000000000000000000);
    preICO.setMinInvestedLimit(100000000000000000);
    preICO.setToken(token);
    preICO.setHardcap(11250000000000000000000);
    token.setSaleAgent(preICO);

    ico = new ICO();

    ico.addMilestone(6, 10);
    ico.addMilestone(6, 9);
    ico.addMilestone(6, 8);
    ico.addMilestone(6, 7);
    ico.addMilestone(6, 6);
    ico.addMilestone(6, 5);
    ico.addMilestone(6, 4);
    ico.addMilestone(6, 3);
    ico.addMilestone(6, 2);
    ico.addMilestone(3, 1);
    ico.addMilestone(3, 0);
    ico.setMinInvestedLimit(100000000000000000);
    ico.setToken(token);
    ico.setPrice(5000000000000000000000);
    ico.setWallet(0x98882D176234AEb736bbBDB173a8D24794A3b085);
    ico.setBountyTokensWallet(0x28732f6dc12606D529a020b9ac04C9d6f881D3c5);
    ico.setStart(1520640000);
    ico.setHardcap(47500000000000000000000);
    ico.setTeamTokensPercent(10);
    ico.setBountyTokensPercent(5);

    teamTokensWallet = new DoubleStageFreezeTokensWallet();
    teamTokensWallet.setMasterPercent(30);
    teamTokensWallet.setWallet(0x2AB0d2630eb67033E7D35eC1C43303a3F7720dA5);
    teamTokensWallet.setToken(token);
    teamTokensWallet.setFirstDate(1543622400);
    teamTokensWallet.setSecondDate(1567296000);
    teamTokensWallet.activate();

    ico.setTeamTokensWallet(teamTokensWallet);

    preICO.setNextSaleAgent(ico);

    address manager = 0x675eDE27cafc8Bd07bFCDa6fEF6ac25031c74766;

    teamTokensWallet.transferOwnership(manager);
    token.transferOwnership(manager);
    preICO.transferOwnership(manager);
    ico.transferOwnership(manager);
  }

}

