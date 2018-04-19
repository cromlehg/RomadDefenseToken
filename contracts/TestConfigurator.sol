pragma solidity ^0.4.18;

import './ownership/Ownable.sol';

contract RomadDefenseToken {
  function setSaleAgent(address newSaleAgent) public;
  function transferOwnership(address newOwner) public;
}

contract PreICO {
  function setWallet(address newWallet) public;
  function setStart(uint newStart) public;
  function setPeriod(uint newPerion) public;
  function setPrice(uint newPrice) public;
  function setMinInvestedLimit(uint newMinInvestedLimit) public;
  function setSoftcap(uint newSoftcap) public;
  function setHardcap(uint newHardcap) public;
  function setNextSaleAgent(address newICO) public;
  function setToken(address newToken) public;
  function transferOwnership(address newOwner) public;
}

contract ICO {
  function addMilestone(uint period, uint bonus) public;
  function setWallet(address newWallet) public;
  function setStart(uint newStart) public;
  function setPrice(uint newPrice) public;
  function setMinInvestedLimit(uint newMinInvestedLimit) public;
  function setHardcap(uint newHardcap) public;
  function setTeamTokensWallet(address newTeamTokensWallet) public;
  function setTeamTokensPercent(uint newTeamTokensPercent) public;
  function setBountyTokensPercent(uint newBountyTokensPercent) public;
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
  DoubleStageFreezeTokensWallet public bountyWallet;
    function setToken(address _token) public onlyOwner {
      token = RomadDefenseToken(_token);
    }

    function setPreICO(address _preICO) public onlyOwner {
      preICO = PreICO(_preICO);
    }

    function setICO(address _ico) public onlyOwner {
      ico = ICO(_ico);
    }

	function setBountyWallet(address _bountyWallet) public onlyOwner {
	  bountyWallet = DoubleStageFreezeTokensWallet(_bountyWallet);
	}

    function deploy() public onlyOwner {
      preICO.setWallet(0xa86780383E35De330918D8e4195D671140A60A74);
      preICO.setStart(1524096000);
      preICO.setPeriod(7);
      preICO.setPrice(6667);
      preICO.setMinInvestedLimit(100000000000000000);
      preICO.setSoftcap(1000000000000000000000);
      preICO.setHardcap(11250000000000000000000);
      preICO.setToken(token);

      token.setSaleAgent(preICO);
      preICO.setNextSaleAgent(ico);

      ico.setWallet(0x98882D176234AEb736bbBDB173a8D24794A3b085);
      ico.setStart(1524096000);
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
      ico.setPrice(5000);
      ico.setMinInvestedLimit(100000000000000000);
      ico.setHardcap(47500000000000000000000);
      ico.setTeamTokensWallet(0x2AB0d2630eb67033E7D35eC1C43303a3F7720dA5);
      ico.setTeamTokensPercent(10);
      ico.setBountyTokensPercent(5);
      ico.setToken(token);

      ico.setBountyTokensWallet(bountyWallet);

      bountyWallet.setWallet(0x28732f6dc12606D529a020b9ac04C9d6f881D3c5);
      bountyWallet.setMasterPercent(30);
      bountyWallet.setFirstDate(1543622400);
      bountyWallet.setSecondDate(1567296000);
      bountyWallet.setToken(token);

      bountyWallet.activate();

      token.transferOwnership(owner);
      preICO.transferOwnership(owner);
      ico.transferOwnership(owner);
      bountyWallet.transferOwnership(owner);
    }
}
