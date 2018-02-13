pragma solidity ^0.4.18;

import './ownership/Ownable.sol';

contract RobustCoin {
  function setSaleAgent(address newSaleAgent) public;
  function transferOwnership(address newOwner) public;
}

contract Presale {
  function setWallet(address newWallet) public;
  function setStart(uint newStart) public;
  function setPeriod(uint newPerion) public;
  function setPrice(uint newPrice) public;
  function setMinInvestedLimit(uint newMinInvestedLimit) public;
  function setSoftcap(uint newSoftcap) public;
  function setHardcap(uint newHardcap) public;
  function setNextSaleAgent(address newMainsale) public;
  function setToken(address newToken) public;
  function transferOwnership(address newOwner) public;
}

contract Mainsale {
  function addMilestone(uint period, uint bonus) public;
  function setWallet(address newWallet) public;
  function setStart(uint newStart) public;
  function setPrice(uint newPrice) public;
  function setMinInvestedLimit(uint newMinInvestedLimit) public;
  function setHardcap(uint newHardcap) public;
  function setFoundersTokensWallet(address newFoundersTokensWallet) public;
  function setFoundersTokensPercent(uint newFoundersTokensPercent) public;
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
    
  RobustCoin public token;
  Presale public presale;
  Mainsale public mainsale;
  DoubleStageFreezeTokensWallet public bountyWallet;
    function setToken(address _token) public onlyOwner {
      token = RobustCoin(_token);
    }

    function setPresale(address _presale) public onlyOwner {
      presale = Presale(_presale);
    }

    function setMainsale(address _mainsale) public onlyOwner {
      mainsale = Mainsale(_mainsale);
    }	
	
	function setBountyWallet(address _bountyWallet) public onlyOwner {
	  bountyWallet = DoubleStageFreezeTokensWallet(_bountyWallet);
	}

    function deploy() public onlyOwner {
      presale.setWallet(0xa86780383E35De330918D8e4195D671140A60A74);
      presale.setStart(1518393600);
      presale.setPeriod(7);
      presale.setPrice(6667000000000000000000);
      presale.setMinInvestedLimit(100000000000000000);
      presale.setSoftcap(1000000000000000000000);
      presale.setHardcap(11250000000000000000000);
      presale.setToken(token);

      token.setSaleAgent(presale);
      presale.setNextSaleAgent(mainsale);
  
      mainsale.setWallet(0x98882D176234AEb736bbBDB173a8D24794A3b085);
      mainsale.setStart(1520640000);
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
      mainsale.setPrice(5000000000000000000000);
      mainsale.setMinInvestedLimit(100000000000000000);
      mainsale.setHardcap(47500000000000000000000);
      mainsale.setFoundersTokensWallet(0x2AB0d2630eb67033E7D35eC1C43303a3F7720dA5);
      mainsale.setFoundersTokensPercent(10);
      mainsale.setBountyTokensPercent(5);
      mainsale.setToken(token);
    
      mainsale.setBountyTokensWallet(bountyWallet);
    
      bountyWallet.setWallet(0x28732f6dc12606D529a020b9ac04C9d6f881D3c5);
      bountyWallet.setMasterPercent(30);
      bountyWallet.setFirstDate(1543622400);
      bountyWallet.setSecondDate(1567296000);
      bountyWallet.setToken(token);
    
      bountyWallet.activate();
    
      token.transferOwnership(owner);
      presale.transferOwnership(owner);
      mainsale.transferOwnership(owner);
      bountyWallet.transferOwnership(owner);
    }
}