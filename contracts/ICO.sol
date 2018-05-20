pragma solidity ^0.4.18;

import './RomadDefenseTokenCommonSale.sol';
import './StagedCrowdsale.sol';

contract ICO is StagedCrowdsale, RomadDefenseTokenCommonSale {

  address public teamTokensWallet;
  address public advisorsTokensWallet;
  address public bountyTokensWallet;
  address public earlyInvestorsTokensWallet;
  uint public hardcap;
  uint public teamTokensPercent;
  uint public advisorsTokensPercent;
  uint public bountyTokensPercent;
  uint public earlyInvestorsTokensPercent;
  uint public USDHardcap;
  uint public USDPrice; // usd per token
  uint public ETHtoUSD; // usd per eth


  modifier isUnderHardcap() {
    require(invested < hardcap);
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

  // three digits
  function setUSDHardcap(uint newUSDHardcap) public onlyOwner {
    USDHardcap = newUSDHardcap;
  }

  function updateHardcap() internal {
    hardcap = USDHardcap.mul(1 ether).div(ETHtoUSD);
  }

  function setUSDPrice(uint newUSDPrice) public onlyOwner {
    USDPrice = newUSDPrice;
  }

  function updatePrice() internal {
    price = ETHtoUSD.mul(1 ether).div(USDPrice);
  }

  function setETHtoUSD(uint newETHtoUSD) public onlyOwner {
    ETHtoUSD = newETHtoUSD;
    updateHardcap();
    updatePrice();
  }

  function calculateTokens(uint _invested) internal returns(uint) {
    uint milestoneIndex = currentMilestone(start);
    Milestone storage milestone = milestones[milestoneIndex];
    require(_invested >= milestone.minInvestedLimit);
    uint tokens = _invested.mul(price).div(1 ether);
    if (milestone.bonus > 0) {
      tokens = tokens.add(tokens.mul(milestone.bonus).div(percentRate));
    }
    return tokens;
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

  function endSaleDate() public view returns(uint) {
    return lastSaleDate(start);
  }

  function mintTokensByETH(address to, uint _invested) internal isUnderHardcap returns(uint) {
    super.mintTokensByETH(to, _invested);
  }

}
