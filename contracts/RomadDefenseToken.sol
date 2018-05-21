pragma solidity ^0.4.18;

import "./MintableToken.sol";

contract RomadDefenseToken is MintableToken {

  string public constant name = "ROMAD Defense token";
  string public constant symbol = "RDT";
  uint32 public constant decimals = 0;
  mapping(address => bool) public KYCPending;

  function addToKYCPending(address customer) public onlyOwnerOrSaleAgent {
    require(!mintingFinished);
    KYCPending[customer] = true;
  }

  function removeFromKYCPending(address customer) public onlyOwnerOrSaleAgent {
    delete KYCPending[customer];
  }

  function burnKYCPendingTokens(address customer) public onlyOwnerOrSaleAgent {
    require(KYCPending[customer]);
    totalSupply = totalSupply.sub(balances[customer]);
    balances[customer] = 0;
  }

  function transfer(address to, uint256 value) public returns (bool) {
    require(!KYCPending[msg.sender]);
    return super.transfer(to, value);
  }

  function transferFrom(address from, address to, uint256 value) public returns (bool) {
    require(!KYCPending[from]);
    return super.transferFrom(from, to, value);
  }

}
