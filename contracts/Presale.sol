pragma solidity 0.4.18;

import './RobustCoinCommonSale.sol';
import './NextSaleAgentFeature.sol';
import './Mainsale.sol';
import './SoftcapFeature.sol';

contract Presale is NextSaleAgentFeature, SoftcapFeature, RobustCoinCommonSale {

  uint public period;

  function calculateTokens(uint _invested) internal returns(uint) {
    return _invested.mul(price).div(1 ether);
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
      token.setSaleAgent(nextSaleAgent);
    }
  }

  function endSaleDate() public view returns(uint) {
    return start.add(period * 1 days);
  }

}
