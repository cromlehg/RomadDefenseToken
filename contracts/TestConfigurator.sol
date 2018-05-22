pragma solidity ^0.4.18;

import './ownership/Ownable.sol';

contract RomadDefenseToken {
  function setSaleAgent(address newSaleAgent) public;
  function transferOwnership(address newOwner) public;
}

contract PreICO {
  function setWallet(address newWallet) public;
  function setStart(uint newStart) public;
  function addMilestone(uint period, uint bonus, uint minInvestedLimit) public;
  function setUSDSoftcap(uint newUSDSoftcap) public;
  function setUSDPrice(uint newUSDPrice) public;
  function setETHtoUSD(uint newETHtoUSD) public;
  function setMinInvestedLimit(uint newMinInvestedLimit) public;
  function setNextSaleAgent(address newICO) public;
  function setToken(address newToken) public;
  function transferOwnership(address newOwner) public;
}

contract ICO {
  function setWallet(address newWallet) public;
  function setStart(uint newStart) public;
  function addMilestone(uint period, uint bonus, uint minInvestedLimit) public;
  function setUSDHardcap(uint newUSDHardcap) public;
  function setUSDPrice(uint newUSDPrice) public;
  function setETHtoUSD(uint newETHtoUSD) public;
  function setMinInvestedLimit(uint newMinInvestedLimit) public;
  function setTeamTokensWallet(address newTeamTokensWallet) public;
  function setTeamTokensPercent(uint newTeamTokensPercent) public;
  function setBountyTokensPercent(uint newBountyTokensPercent) public;
  function setAdvisorsTokensWallet(address newAdvisorsTokensWallet) public;
  function setAdvisorsTokensPercent(uint newAdvisorsTokensPercent) public;
  function setEarlyInvestorsTokensWallet(address newEarlyInvestorsTokensWallet) public;
  function setEarlyInvestorsTokensPercent(uint newBountyTokensPercent) public;
  function setBountyTokensWallet (address newBountyWallet) public;
  function setToken(address newToken) public;
  function transferOwnership(address newOwner) public;
}

contract DoubleStageFreezeTokensWallet {
  function setWallet(address newWallet) public;
  function setMasterPercent(uint newPercent) public;
  function setFirstDate(uint newFirstDate) public;
  function setSecondDate(uint newSecondDate) public;
  function activate() public;
  function setToken(address newToken) public;
  function transferOwnership(address newOwner) public;
}

contract TestConfigurator is Ownable {

  RomadDefenseToken public token;
  PreICO public preICO;
  ICO public ico;
  DoubleStageFreezeTokensWallet public teamTokensWallet;
  DoubleStageFreezeTokensWallet public earlyInvestorsTokensWallet;

  function setToken(address _token) public onlyOwner {
    token = RomadDefenseToken(_token);
  }

  function setPreICO(address _preICO) public onlyOwner {
    preICO = PreICO(_preICO);
  }

  function setICO(address _ico) public onlyOwner {
    ico = ICO(_ico);
  }

  function setTeamTokensWallet(address _teamTokensWallet) public onlyOwner {
    teamTokensWallet = DoubleStageFreezeTokensWallet(_teamTokensWallet);
  }

  function setEarlyInvestorsTokensWallet(address _earlyInvestorsTokensWallet) public onlyOwner {
    earlyInvestorsTokensWallet = DoubleStageFreezeTokensWallet(_earlyInvestorsTokensWallet);
  }

  function deploy() public onlyOwner {

    token.setSaleAgent(preICO);

    preICO.setWallet(0x8fD94be56237EA9D854B23B78615775121Dd1E82);
    preICO.setStart(1527033600); // 23 May 2018 00:00:00 GMT
    preICO.addMilestone(1, 20, 1000000000000000000); // 1 day, 20% bonus, 1 ETH min
    preICO.addMilestone(2, 18, 500000000000000000); // 2 days, 20% bonus, 0.5 ETH min
    preICO.addMilestone(4, 16, 100000000000000000); // 4 days 16%, 0.1 ETH min
    preICO.addMilestone(3, 15, 0);
    preICO.addMilestone(3, 14, 0);
    preICO.addMilestone(3, 13, 0);
    preICO.addMilestone(3, 12, 0);
    preICO.addMilestone(3, 11, 0);
    preICO.setUSDPrice(200); // 0.2 USD
    preICO.setUSDSoftcap(500000); //  500 USD
    preICO.setETHtoUSD(67508); // 675.08 USD per ETH
    preICO.setMinInvestedLimit(100000000000000000); // 0.1 ETH fallback limit
    preICO.setToken(token);
    preICO.setNextSaleAgent(ico);

    ico.setWallet(0x8fD94be56237EA9D854B23B78615775121Dd1E82);
    ico.setStart(1527033600); // 23 May 2018 00:00:00 GMT
    ico.addMilestone(6, 10, 0);
    ico.addMilestone(6, 9, 0);
    ico.addMilestone(6, 8, 0);
    ico.addMilestone(6, 7, 0);
    ico.addMilestone(6, 6, 0);
    ico.addMilestone(6, 5, 0);
    ico.addMilestone(6, 4, 0);
    ico.addMilestone(6, 3, 0);
    ico.addMilestone(6, 2, 0);
    ico.addMilestone(3, 1, 0);
    ico.addMilestone(3, 0, 0);
    ico.setUSDPrice(200); // 0.2 USD
    ico.setUSDHardcap(28000000000); // 28 000 000 USD
    ico.setETHtoUSD(67508); // 675.08 USD per ETH
    ico.setBountyTokensWallet(0x8Ba7Aa817e5E0cB27D9c146A452Ea8273f8EFF29);
    ico.setBountyTokensPercent(5);
    ico.setTeamTokensPercent(10);
    ico.setAdvisorsTokensWallet(0x24a7774d0eba02846580A214eeca955214cA776C);
    ico.setAdvisorsTokensPercent(5);
    ico.setEarlyInvestorsTokensPercent(15);
    ico.setMinInvestedLimit(100000000000000000); // 0.1 ETH fallback limit
    ico.setToken(token);
    ico.setTeamTokensWallet(teamTokensWallet);
    ico.setEarlyInvestorsTokensWallet(earlyInvestorsTokensWallet);

    teamTokensWallet.setMasterPercent(30);
    teamTokensWallet.setWallet(0x8fD94be56237EA9D854B23B78615775121Dd1E82);
    teamTokensWallet.setToken(token);
    teamTokensWallet.setFirstDate(1527120000); // 24 May 2018 00:00:00 GMT
    teamTokensWallet.setSecondDate(1527206400); // 25 May 2018 00:00:00 GMT
    teamTokensWallet.activate();

    earlyInvestorsTokensWallet.setMasterPercent(50);
    earlyInvestorsTokensWallet.setWallet(0x8fD94be56237EA9D854B23B78615775121Dd1E82);
    earlyInvestorsTokensWallet.setToken(token);
    earlyInvestorsTokensWallet.setFirstDate(1527120000); // 24 May 2018 00:00:00 GMT
    earlyInvestorsTokensWallet.setSecondDate(1527206400); // 25 May 2018 00:00:00 GMT
    earlyInvestorsTokensWallet.activate();

    address manager = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c; //0x8fD94be56237EA9D854B23B78615775121Dd1E82;

    token.transferOwnership(manager);
    preICO.transferOwnership(manager);
    ico.transferOwnership(manager);
    teamTokensWallet.transferOwnership(manager);
    earlyInvestorsTokensWallet.transferOwnership(manager);

  }
}
