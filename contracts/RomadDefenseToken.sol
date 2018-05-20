pragma solidity ^0.4.18;

import './MintableToken.sol';

contract RomadDefenseToken is MintableToken {

  string public constant name = "ROMAD Defense token";

  string public constant symbol = "RDT";

  uint32 public constant decimals = 0;

  mapping(address => bool) public approvedCustomers;

  function approveCustomer(address customer) public onlyOwner {
    approvedCustomers[customer] = true;
  }

  function transfer(address _to, uint256 _value) public returns (bool) {
    require(approvedCustomers[msg.sender]);
    return super.transfer(_to, _value);
  }

  function transferFrom(address from, address to, uint256 value) public returns (bool) {
    require(approvedCustomers[from]);
    return super.transferFrom(from, to, value);
  }

}
