pragma solidity 0.4.18;

import './math/SafeMath.sol';
import './PercentRateProvider.sol';
import './token/StandardToken.sol';
import './WalletProvider.sol';

contract DoubleStageFreezeTokensWallet is PercentRateProvider, WalletProvider {

  using SafeMath for uint;

  uint public firstDate;

  uint public secondDate;

  uint public masterPercent;

  StandardToken public token;

  bool public activated;

  modifier notActivated() {
    require(!activated);
    _;
  }

  function setToken(address newToken) public onlyOwner notActivated {
    token = StandardToken(newToken);
  }

  function setMasterPercent(uint newMasterPercent) public onlyOwner notActivated {
    masterPercent = newMasterPercent;
  }

  function setFirstDate(uint newFirstDate) public onlyOwner notActivated {
    firstDate = newFirstDate;
  }

  function setSecondDate(uint newSecondDate) public onlyOwner notActivated {
    secondDate = newSecondDate;
  }

  function activate() public onlyOwner notActivated {
    activated = true;
  }

  function widthdraw() public {
    require(activated);
    if(now > firstDate) token.transfer(wallet, token.balanceOf(this).mul(masterPercent).div(percentRate));
    if(now > secondDate) token.transfer(wallet, token.balanceOf(this));
  }

}
