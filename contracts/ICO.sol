pragma solidity ^0.4.18;

import './CommonSale.sol';

contract ICO is CommonSale {

  address public teamTokensWallet;
  address public advisorsTokensWallet;
  address public bountyTokensWallet;
  address public earlyInvestorsTokensWallet;
  uint public teamTokensPercent;
  uint public advisorsTokensPercent;
  uint public bountyTokensPercent;
  uint public earlyInvestorsTokensPercent;
  uint public hardcap;
  uint public USDHardcap;

  modifier isUnderHardcap() {
    require(weiApproved < hardcap);
    _;
  }

  function setHardcap(uint newHardcap) public onlyOwner {
    hardcap = newHardcap;
  }

  function setTeamTokensPercent(uint newTeamTokensPercent) public onlyOwner {
    teamTokensPercent = newTeamTokensPercent;
  }

  function setAdvisorsTokensPercent(uint newAdvisorsTokensPercent) public onlyOwner {
    advisorsTokensPercent = newAdvisorsTokensPercent;
  }

  function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner {
    bountyTokensPercent = newBountyTokensPercent;
  }

  function setEarlyInvestorsTokensPercent(uint newEarlyInvestorsTokensPercent) public onlyOwner {
    earlyInvestorsTokensPercent = newEarlyInvestorsTokensPercent;
  }

  function setTeamTokensWallet(address newTeamTokensWallet) public onlyOwner {
    teamTokensWallet = newTeamTokensWallet;
  }

  function setAdvisorsTokensWallet(address newAdvisorsTokensWallet) public onlyOwner {
    advisorsTokensWallet = newAdvisorsTokensWallet;
  }

  function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner {
    bountyTokensWallet = newBountyTokensWallet;
  }

  function setEarlyInvestorsTokensWallet(address newEarlyInvestorsTokensWallet) public onlyOwner {
    earlyInvestorsTokensWallet = newEarlyInvestorsTokensWallet;
  }

  function endSaleDate() public view returns(uint) {
    return lastSaleDate(start);
  }

  function mintTokensByETH(address _to, uint _invested) internal isUnderHardcap returns(uint) {
    super.mintTokensByETH(_to, _invested);
  }

  function finish() public onlyOwner {
    uint summaryTokensPercent = bountyTokensPercent.add(teamTokensPercent).add(earlyInvestorsTokensPercent).add(advisorsTokensPercent);
    uint mintedTokens = token.totalSupply();
    uint allTokens = mintedTokens.mul(percentRate).div(percentRate.sub(summaryTokensPercent));
    uint foundersTokens = allTokens.mul(teamTokensPercent).div(percentRate);
    uint bountyTokens = allTokens.mul(bountyTokensPercent).div(percentRate);
    uint earlyInvestorsTokens = allTokens.mul(earlyInvestorsTokensPercent).div(percentRate);
    uint advisorsTokens = allTokens.mul(advisorsTokensPercent).div(percentRate);
    mintTokens(teamTokensWallet, foundersTokens);
    mintTokens(bountyTokensWallet, bountyTokens);
    mintTokens(earlyInvestorsTokensWallet, earlyInvestorsTokens);
    mintTokens(advisorsTokensWallet, advisorsTokens);
    token.finishMinting();
  }

  // --------------------------------------------------------------------------
  // USD conversion
  // --------------------------------------------------------------------------

  function setUSDHardcap(uint _USDHardcap) public onlyOwner {
    USDHardcap = _USDHardcap;
  }

  function updateHardcap() internal {
    hardcap = USDHardcap.mul(1 ether).div(ETHtoUSD);
  }

  function setETHtoUSD(uint _ETHtoUSD) public onlyOwner {
    super.setETHtoUSD(_ETHtoUSD);
    updateHardcap();
  }

}
