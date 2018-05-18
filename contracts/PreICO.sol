pragma solidity ^0.4.18;

import './RomadDefenseTokenCommonSale.sol';
import './NextSaleAgentFeature.sol';
import './ICO.sol';
import './SoftcapFeature.sol';

contract PreICO is StagedCrowdsale, NextSaleAgentFeature, SoftcapFeature, RomadDefenseTokenCommonSale {

  uint public period;
  uint public USDSoftcap;
  uint public USDPrice; // usd per token
  uint public ETHtoUSD; // usd per eth

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

  function mintTokensByETH(address to, uint _invested) internal returns(uint) {
    uint _tokens = super.mintTokensByETH(to, _invested);
    updateBalance(to, _invested);
    return _tokens;
  }

  function setPeriod(uint newPeriod) public onlyOwner {
    period = newPeriod;
  }

  function finish() public onlyOwner {
    if (updateRefundState()) {
      token.finishMinting();
    } else {
      withdraw();
      token.setSaleAgent(nextSaleAgent);
    }
  }

  function endSaleDate() public view returns(uint) {
    return lastSaleDate(start);
  }

  // three digits
  function setUSDSoftcap(uint newUSDSoftcap) public onlyOwner {
    USDSoftcap = newUSDSoftcap;
  }

  function setUSDPrice(uint newUSDPrice) public onlyDirectMintAgentOrOwner {
    USDPrice = newUSDPrice;
  }

  function updateSoftcap() internal {
    softcap = USDSoftcap.mul(1 ether).div(ETHtoUSD);
  }

  function updatePrice() internal {
    price = ETHtoUSD.mul(1 ether).div(USDPrice);
  }

  function setETHtoUSD(uint newETHtoUSD) public onlyDirectMintAgentOrOwner {
    ETHtoUSD = newETHtoUSD;
    updateSoftcap();
    updatePrice();
  }

  function fallback() internal minInvestLimited(msg.value) returns(uint) {
    require (now >= start && now < endSaleDate());
    return mintTokensByETH(msg.sender, msg.value);
  }

}
