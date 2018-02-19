pragma solidity ^0.4.18;

import './MintableToken.sol';

contract SafetyToken is MintableToken {

  string public constant name = "SafetyToken";

  string public constant symbol = "RIC";

  uint32 public constant decimals = 18;

}
