pragma solidity ^0.4.18;

import "./CommonSale.sol";
import "./NextSaleAgentFeature.sol";

contract PreICO is CommonSale, NextSaleAgentFeature {

  bool public softcapReached = false;
  bool public refundOn = false;
  uint public softcap;
  uint public USDSoftcap;
  uint public constant devLimit = 19500000000000000000;
  address public constant devWallet = 0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770;

  // --------------------------------------------------------------------------
  // Common
  // --------------------------------------------------------------------------

  function endSaleDate() public view returns(uint) {
    return lastSaleDate(start);
  }

  function mintTokensByETH(address to, uint invested) internal returns(uint) {
    super.mintTokensByETH(to, invested);
    if (!softcapReached && weiApproved >= softcap) {
      softcapReached = true;
    }
  }

  function withdraw() public {
    require(msg.sender == owner || msg.sender == devWallet);
    require(softcapReached);
    devWallet.transfer(devLimit);
    wallet.transfer(weiApproved);
  }

  function finish() public onlyOwner {
    if (updateRefundState()) {
      token.finishMinting();
    } else {
      withdraw();
      token.setSaleAgent(nextSaleAgent);
    }
  }

  function updateRefundState() internal returns(bool) {
    if (!softcapReached) {
      refundOn = true;
    }
    return refundOn;
  }

  function refund() public {
    if (refundOn) {
      require(balances[msg.sender] > 0);
      uint value = balances[msg.sender];
      balances[msg.sender] = 0;
      msg.sender.transfer(value);
    } else {
      super.refund();
    }
  }

  // --------------------------------------------------------------------------
  // USD conversion
  // --------------------------------------------------------------------------

  function setUSDSoftcap(uint newUSDSoftcap) public onlyOwner {
    USDSoftcap = newUSDSoftcap;
  }

  function updateSoftcap() internal {
    softcap = USDSoftcap.mul(1 ether).div(ETHtoUSD);
  }

  function setETHtoUSD(uint _ETHtoUSD) public onlyOwner {
    super.setETHtoUSD(_ETHtoUSD);
    updateSoftcap();
  }

  // --------------------------------------------------------------------------
  // Fallback
  // --------------------------------------------------------------------------

  function fallback() internal minInvestLimited(msg.value) returns(uint) {
    require (now >= start && now < endSaleDate());
    return mintTokensByETH(msg.sender, msg.value);
  }

}
