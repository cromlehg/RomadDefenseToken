pragma solidity ^0.4.18;

import "./ownership/Ownable.sol";

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

contract Configurator is Ownable {

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

    preICO.setWallet(0xa86780383E35De330918D8e4195D671140A60A74);
    preICO.setStart(1530118800); // 27 Jun 2018 17:00:00 GMT
    preICO.addMilestone(1, 20, 10000000000000000000); // 1 day, 20% bonus, 10 ETH min
    preICO.addMilestone(2, 18, 5000000000000000000); // 2 days, 18% bonus, 5 ETH min
    preICO.addMilestone(4, 16, 1000000000000000000); // 4 days, 16% bonus, 1 ETH min
    preICO.addMilestone(3, 15, 0);
    preICO.addMilestone(3, 14, 0);
    preICO.addMilestone(3, 13, 0);
    preICO.addMilestone(3, 12, 0);
    preICO.addMilestone(3, 11, 0);
    preICO.setUSDPrice(200); // 1 USD = 5 RDT
    preICO.setUSDSoftcap(5000000000); //  5 000 000 USD
    preICO.setETHtoUSD(589330); // 1 ETH = 589.33 USD
    preICO.setMinInvestedLimit(100000000000000000); // 0.1 ETH fallback limit
    preICO.setToken(token);
    preICO.setNextSaleAgent(ico);

    ico.setWallet(0x98882D176234AEb736bbBDB173a8D24794A3b085);
    ico.setStart(1532538000); // Jul 25 2018 17:00:00 GMT
    ico.addMilestone(6, 10, 0);
    ico.addMilestone(6, 9, 0);
    ico.addMilestone(6, 8, 0);
    ico.addMilestone(6, 7, 0);
    ico.addMilestone(6, 6, 0);
    ico.addMilestone(6, 5, 0);
    ico.addMilestone(6, 4, 0);
    ico.addMilestone(6, 3, 0);
    ico.addMilestone(6, 2, 0);
    ico.addMilestone(6, 1, 0);
    ico.addMilestone(6, 0, 0);
    ico.setUSDPrice(200); // 1 USD = 5 RDT
    ico.setUSDHardcap(28000000000); // 28 000 000 USD
    ico.setETHtoUSD(589330); // 1 ETH = 589.33 USD
    ico.setBountyTokensWallet(0x28732f6dc12606D529a020b9ac04C9d6f881D3c5);
    ico.setBountyTokensPercent(5);
    ico.setTeamTokensPercent(10);
    ico.setAdvisorsTokensWallet(0xE7260D4c2a6539910d47F91c9060B4269dF2bD45);
    ico.setAdvisorsTokensPercent(5);
    ico.setEarlyInvestorsTokensPercent(15);
    ico.setMinInvestedLimit(100000000000000000); // 0.1 ETH fallback limit
    ico.setToken(token);
    ico.setTeamTokensWallet(teamTokensWallet);
    ico.setEarlyInvestorsTokensWallet(earlyInvestorsTokensWallet);

    teamTokensWallet.setMasterPercent(30);
    teamTokensWallet.setWallet(0x2AB0d2630eb67033E7D35eC1C43303a3F7720dA5);
    teamTokensWallet.setToken(token);
    teamTokensWallet.setFirstDate(1543622400); // 01 Dec 2018 00:00:00 GMT
    teamTokensWallet.setSecondDate(1567296000); // 01 Sep 2019 00:00:00 GMT
    teamTokensWallet.activate();

    earlyInvestorsTokensWallet.setMasterPercent(50);
    earlyInvestorsTokensWallet.setWallet(0xf3Eafc283C0fFa5C60206bd65D9753474c1aE48a);
    earlyInvestorsTokensWallet.setToken(token);
    earlyInvestorsTokensWallet.setFirstDate(1543622400); // 01 Dec 2018 00:00:00 GMT
    earlyInvestorsTokensWallet.setSecondDate(1567296000); // 01 Sep 2019 00:00:00 GMT
    earlyInvestorsTokensWallet.activate();

    address manager = 0x675eDE27cafc8Bd07bFCDa6fEF6ac25031c74766;

    token.transferOwnership(manager);
    preICO.transferOwnership(manager);
    ico.transferOwnership(manager);
    teamTokensWallet.transferOwnership(manager);
    earlyInvestorsTokensWallet.transferOwnership(manager);

  }
}
